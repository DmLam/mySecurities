import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'common/utils.dart';
import 'exchange.dart';
import 'models/instrument.dart';
import 'models/quote.dart';
import 'models/rate.dart';
import 'stock_exchange_interface.dart';

// текущие котировки
// https://iss.moex.com/iss/engines/stock/markets/shares/boards/TQTF/securities/FXMM.json?iss.meta=off&iss.only=marketdata&marketdata.columns=SECID,LAST

class _Market {
  int id;
  String name;
  int engineId;

  _Market(this.id, this.name, this.engineId);
}

class _Board {
  int id;
  String name;
  int marketId;
  int engineId;

  _Board(this.id, this.name, this.marketId, this.engineId);
}

class MOEXDataProvider implements StockExchangeProvider {
  static const String _MOEX_URL = 'iss.moex.com';
  Map<int, String> _engines = Map<int, String>();
  Map<int, _Market> _markets = Map<int, _Market>();
  Map<String, _Board> _boards = Map<String, _Board>();

  Future<Uint8List?> _svgToPng(Uint8List svgBytes) async {
    final DrawableRoot svgDrawableRoot = await svg.fromSvgBytes(svgBytes, '');
    final ui.Picture picture = svgDrawableRoot.toPicture(size: Size(30, 30));
    final ui.Image image = await picture.toImage(30, 30);
    final ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return bytes?.buffer?.asUint8List();
  }

  Future _initMoex() async {
    if (_boards.length == 0) {
      Uri initUri = Uri.https(_MOEX_URL, '/iss/index.json', {
        'iss.meta': 'off',
        'engines.columns': 'id,name',
        'markets.columns': 'id,trade_engine_id,market_name',
        'boards.columns': 'id,engine_id,market_id,boardid,is_traded'
      });
      http.Response response = await http.get(initUri);
      if (response.statusCode != 200)
        throw Exception("Error initializing MOEX provider");

      Map<String, dynamic> r = jsonDecode(response.body);

      for (var row in r['engines']['data']) {
        _engines[row[0].toInt()] = row[1].toString();
      }
      for (var row in r['markets']['data']) {
        _markets[row[0].toInt()] = _Market(row[0].toInt(), row[2], row[1].toInt());
      }

      for (var row in r['boards']['data']) {
        if (row[4] == 1) { // is_traded
          _boards[row[3]] = _Board(row[0].toInt(), row[3], row[2].toInt(), row[1].toInt());
        }
      }
    }
  }

  String? getCurrencyTicker(Currency currency) {
    switch (currency) {
      case Currency.RUB:
        return null;
      case Currency.CHF:
        return "CHFRUB_TOD";
      case Currency.CNY:
        return "CNY000000TOD";
      case Currency.EUR:
        return "EUR_RUB__TOD";
      case Currency.GBP:
        return null;
      case Currency.HKD:
        return "HKDRUB_TOD";
      case Currency.JPY:
        return "JPYRUB_TOD";
      case Currency.TRY:
        return "TRYRUB_TOD";
      case Currency.USD:
        return "USD000000TOD";
      default:
        throw Exception("There is no ticker for currency " + currency.name);
    }
  }

  // list of tickers that have not image to don't try to retrive them more than 1
  // time
  List<String> _noImageInstruments = [];

  @override
  Future<Uint8List?> getInstrumentImage(Instrument instrument) async {
    Uint8List? result;
    String? type;

    // if we already have tried to get this image and didn't received -
    // don't try again
    if (!_noImageInstruments.contains(instrument.ticker)) {
      switch (instrument.type) {
        case InstrumentType.share:
          type = 'shares';
          break;
        case InstrumentType.etf:
          type = 'etfs';
          break;
        case InstrumentType.corporateBond:
        case InstrumentType.federalBond:
        case InstrumentType.subfederalBond:
          type = 'bonds';
          break;
        case InstrumentType.currency:
          type = 'currencies';
          break;
        default:
          type = null;
          break;
      }
      if (type != null) {
        http.Response response;
        Uri instrumentPageURI = Uri.https(
            'place.moex.com', 'products/$type/${instrument.ticker}');
        response = await http.get(instrumentPageURI);
        if (response.statusCode == 200) {
          // https://api-marketplace.moex.com//media/1238/yandex.svg
          RegExp reImageURL = RegExp(
              r"https://api-marketplace.moex.com//(media/\d+/\w+.svg)");
          RegExpMatch? matches = reImageURL.firstMatch(response.body);

          if (matches != null && matches.start < matches.end) {
            String? path = matches.group(1);

            if (path != null) {
              Uri imageURI = Uri.https('api-marketplace.moex.com', path);

              response = await http.get(imageURI);
              if (response.statusCode == 200 && response.bodyBytes != null) {
                Uint8List? pngData = await _svgToPng(response.bodyBytes);

                result = pngData;
              }
              else if (response.statusCode == 404)
                _noImageInstruments.add(instrument.ticker);
            }
          }
        }
      }
      else
        _noImageInstruments.add(instrument.ticker);
//        throw FormatException('Error loading ticker''s image');
    }

    return Future<Uint8List>.value(result);
  }

  @override
  Future<List?> search({required String ticker}) async {
    final MAX_RESULT_COUNT = 10;
    http.Response response;
    Uri searchURI = Uri.https(_MOEX_URL, '/iss/securities.json', {
      'q': ticker.toUpperCase(),
      'limit': MAX_RESULT_COUNT.toString(),
      'securities.columns': 'name,shortname,isin,secid,primary_boardid,is_traded,type',
      'iss.meta': 'off',
      'engines.columns': 'id,name',
      'markets.columns': 'id,trade_engine_id,board_id,market_name'
    });
    List? result;

    if (ticker.isNotEmpty && ticker.length > 1) {
      try {
        response = await http.get(searchURI);
        if (response.statusCode != 200)
          throw Exception("Error searching instrument");

        result = [];
        Map<String, dynamic> r = jsonDecode(response.body);
        List securities = r['securities']['data'];

        for (var row in securities) {
          String isin = row[2];
          bool isTraded = row[5] == 1;

          if (isin != '' && isTraded) {
            String name = row[0];
            String shortName = row[1];
            String ticker = row[3];
            String board = row[4];
            String type = row[6];
            InstrumentType? instrumentType =
            type == 'currency' ? InstrumentType.currency :
            type == 'common_share' ? InstrumentType.share :
            type.endsWith('ppif') ? InstrumentType.etf :
            type == 'futures' ? InstrumentType.futures :
            type == 'ofz_bond' ? InstrumentType.federalBond :
            type == 'subfederal_bond' ? InstrumentType.subfederalBond :
            type == 'corporate_bond' ? InstrumentType.corporateBond :
            type == 'stock_index' ? InstrumentType.stockIndex :
            type == 'depositary_receipt' ? InstrumentType.depositaryReceipt :
            null;

            if (instrumentType == null)
              throw Exception("Unknown instrument type: $type");
            // получим валюту
            final Currency? currency = await _getInstrumentCurrency(ticker, board);
            if (currency != null)
              result.add(
                  SearchItem(
                      exchange: Exchange.MCX,
                      ticker: ticker,
                      name: name,
                      shortName: shortName,
                      isin: isin,
                      type: instrumentType,
                      currency: currency,
                      additional: board));
          }
        }
      }
      catch (E) {
        result = null;
      }
    }

    return Future.value(result);
  }

  final Map<String, String> _instrumentBoardCache = {};

  Future<String?> _getInstrumentBoard(String ticker) async {
    String? result;

    if (ticker.isNotEmpty) {
      result = _instrumentBoardCache[ticker];
      if (result == null) {
        Uri searchURI = Uri.https(_MOEX_URL, '/iss/securities.json', {
          'q': ticker.toUpperCase(),
          'securities.columns': 'secid,primary_boardid',
          'iss.meta': 'off'
        });
        try {
          http.Response response = await http.get(searchURI);
          if (response.statusCode != 200)
            throw Exception("Error searching instrument");

          Map<String, dynamic> r = jsonDecode(response.body);
          List securities = r['securities']['data'];
          if (securities.isNotEmpty) {
            for (List sec in securities) {
              if (sec[0] == ticker) {
                result = sec[1];
                if (result != null)
                  _instrumentBoardCache[ticker] = result;
                break;
              }
            }
          }
        }
        catch (e) {
          result = null;
        }
      }
    }

    return Future.value(result);
  }

  Future<String?> _getBoardMarket(String boardName) async {
    await _initMoex();

    return _markets[_boards[boardName]?.marketId]?.name;
  }

  Future<String?> _getBoardEngine(String boardName) async {
    _initMoex();

    return _engines[_markets[_boards[boardName]?.marketId]?.engineId];
  }

  Currency? _currencyIdToCurrency(String currencyId) {
    switch (currencyId) {
      case 'SUR':
      case 'RUB':
        return Currency.RUB;
      case 'USD':
        return Currency.USD;
      case 'EUR':
        return Currency.EUR;
      case 'GBP':
        return Currency.GBP;
      case 'HKD':
        return Currency.HKD;
      case 'CHF':
        return Currency.CHF;
      case 'JPY':
        return Currency.JPY;
      case 'CNY':
        return Currency.CNY;
      case 'TRY':
        return Currency.TRY;
    }

    return null;
  }

  Future<Currency?> _getInstrumentCurrency(String ticker, String board) async {
    Currency? result;
    http.Response response;
    String? market = await _getBoardMarket(board), engine = await _getBoardEngine(board);
    Uri searchURI = Uri.https(_MOEX_URL,
        '/iss/engines/$engine/markets/$market/boards/$board/securities/$ticker.json',
        {
          'iss.only': 'securities',
          'securities.columns': 'CURRENCYID',
          'iss.meta': 'off'
        });

    if (ticker.isNotEmpty) {
      try {
        response = await http.get(searchURI);
        if (response.statusCode == 200) {
          Map<String, dynamic> r = jsonDecode(response.body);
          List securities = r['securities']['data'];
          if (securities.isNotEmpty) {
            String currencyId = securities[0][0];

            result = _currencyIdToCurrency(currencyId);
          }
        }
      }
      catch (Exception) {
        result = null;
      }
    }

    return result;
  }

  @override
  Future<double?> getInstrumentLastQuote(String ticker) async {
    double? result;
    String? board = await _getInstrumentBoard(ticker);
    if (board != null) {
      String? market = await _getBoardMarket(board), engine = await _getBoardEngine(board);
      Uri searchURI = Uri.https(_MOEX_URL,
          '/iss/engines/$engine/markets/$market/boards/$board/securities/$ticker.json',
          {
            'iss.only': 'securities',
            'securities.columns': 'SECID,PREVADMITTEDQUOTE',
            'iss.meta': 'off'
          });

      try {
        http.Response response = await http.get(searchURI);
        if (response.statusCode != 200)
          throw Exception("Error retrieving quote");

        Map<String, dynamic> r = jsonDecode(response.body);

        List data = r['securities']['data'];

        result = data[0][1].toDouble();
      }
      catch (Exception) {
        result = null;
      }
    }

    return Future.value(result);
  }

  Future<double?> _getInstrumentHistoryPrice(String ticker, DateTime date) async {
    double? result;
    String? board = await _getInstrumentBoard(ticker);

    if (board != null) {
      final String? market = await _getBoardMarket(board);

      if (market != null) {
        final String? engine = await _getBoardEngine(board);

        if (engine != null) {
          final String from = DateFormat('yyyy-MM-dd').format(date);
          Uri searchURI = Uri.https(_MOEX_URL,
              '/iss/history/engines/$engine/markets/$market/sessions/total/securities/$ticker.json',
              {
                'iss.only': 'history',
                'history.columns': 'BOARDID,CLOSE',
                'iss.meta': 'off',
                'from': from,
                'till': from
              });

          try {
            http.Response response = await http.get(searchURI);
            if (response.statusCode != 200)
              throw Exception("Error retrieving quote");

            Map<String, dynamic> r = jsonDecode(response.body);
            List data = r['history']['data'];

            List? row = data.firstWhere((e) => e[0] == board, orElse: null);

            if (row != null && row[1] != null &&
                (row[1] is int || row[1] is double)) {
              result = row[1].toDouble();
            }
          }
          catch (Exception) {
            result = null;
          }
        }
      }
    }

    return Future.value(result);
  }

  @override
  Future<double?> getInstrumentPrice(String ticker, {DateTime? date}) async {
    double? result;

    date ??= DateTime.now();
    date = dateOf(date); // delete time from date

    if (date.isBefore(currentDate()))
      result = await _getInstrumentHistoryPrice(ticker, date);
    else {
      final String? board = await _getInstrumentBoard(ticker);

      if (board != null) {
        final String? market = await _getBoardMarket(board);

        if (market != null) {
          final String? engine = await _getBoardEngine(board);

          if (engine != null) {
            Uri searchURI = Uri.https(_MOEX_URL,
                '/iss/engines/$engine/markets/$market/boards/$board/securities/$ticker.json',
                {
                  'iss.only': 'marketdata,securities',
                  'marketdata.columns': 'SECID,LAST',
                  'securities.columns': 'SECID,PREVPRICE',
                  'iss.meta': 'off'
                });

            try {
              http.Response response = await http.get(searchURI);
              if (response.statusCode != 200)
                throw Exception("Error retrieving quote");

              Map<String, dynamic> r = jsonDecode(response.body);

              List? data = r['marketdata']['data'];

              if (data != null && data[0][1] != null &&
                  (data[0][1] is double || data[0][1] is int)) {
                result = data[0][1].toDouble();
              }
              else {
                // биржа не работает и текущей цены нет, есть только последняя цена на вчера
                data = r['securities']['data'];

                if (data != null && data[0][1] != null &&
                    (data[0][1] is double || data[0][1] is int)) {
                  result = data[0][1].toDouble();
                }
              }
            }
            catch (Exception) {
              result = null;
            }
          }
        }
      }
    }

    return Future.value(result);
  }

  @override
  Future<List<Quote>> getInstrumentQuotes(String ticker, DateTime from, DateTime? to) async {
    List<Quote> result = [];
    String? board = await _getInstrumentBoard(ticker);

    if (board != null) {
      final String? market = await _getBoardMarket(board);
      if (market != null) {
        final String? engine = await _getBoardEngine(board);

        if (engine != null) {
          try {
            int received,
                start = 0;
            result = <Quote>[];
            // Данные отдаются порциями по 100 строк, поэтому крутим цикл пока не получим все
            do {
              Uri searchURI;
              Map<String, String> queryParams = {
                'from': DateFormat('yyyy-MM-dd').format(from),
                'history.columns': 'TRADEDATE,OPEN,CLOSE,HIGH,LOW',
                'iss.only': 'securities',
                'iss.meta': 'off',
                'start': start.toString()
              };
              if (to != null) {
                queryParams['till'] = DateFormat('yyyy-MM-dd').format(
                    DateTime(to.year, to.month, to.day));
              }
              searchURI = Uri.https(_MOEX_URL,
                  '/iss/history/engines/$engine/markets/$market/boards/$board/securities/$ticker.json',
                  queryParams);
              http.Response response = await http.get(searchURI);

              if (response.statusCode != 200)
                throw Exception("Error retrieving quotes");

              Map<String, dynamic> r = jsonDecode(response.body);
              List data = r['history']['data'];

              received = 0;
              for (var row in data) {
                DateTime date = DateTime.parse(row[0]);
                double open = row[1]?.toDouble() ?? 0.0;
                double low = row[2]?.toDouble() ?? 0.0;
                double high = row[3]?.toDouble() ?? 0.0;
                double close = row[4]?.toDouble() ?? 0.0;

                result.add(Quote(date: date,
                    open: open,
                    low: low,
                    high: high,
                    close: close
                ));
                received++;
              }
              start += received;
            } while (received > 0);
          }
          catch (Exception) {
            result = [];
          }
        }
      }
    }

    return Future.value(result);
  }

  Future<double>? _currencyRate(String ticker, DateTime? datetime) async {
    double? result;

    if (datetime == null) {
      result = await getInstrumentPrice(ticker);
    }
    else {
      List<Quote>? ql = await getInstrumentQuotes(ticker, datetime, datetime);
      if (ql == null || ql.length == 0)
        throw Exception("Can't retrieve rate for " + ticker);
      result = ql[0].close;
    }

    return Future.value(result);
  }

  Future<double?> getCurrencyRate(Currency from, Currency to, {DateTime? datetime}) async{
    double? result;

    if (from == to)
      result = 1.0;
    else {
      if (from != Currency.RUB && to != Currency.RUB) {
        double? rateFrom = await getCurrencyRate(from, Currency.RUB, datetime: datetime);
        double? rateTo = await getCurrencyRate(Currency.RUB, to, datetime: datetime);

        if (rateFrom != null && rateTo != null)
          result = rateFrom * rateTo;
      }
      else {
        if (from == Currency.RUB) {
          String? ticker = getCurrencyTicker(to);

          if (ticker != null)
            result = await _currencyRate(ticker, datetime);
        }
        else {
          String? ticker = getCurrencyTicker(from);

          if (ticker != null) {
            double? rate = await _currencyRate(ticker, datetime);

            if (rate != null)
              result = 1 / rate;
          }
        }
      }
    }

    return Future.value(result);
  }

  Future<List<Rate>> getCurrencyRates(Currency currency, DateTime from, DateTime? to) async {
    List<Rate> result = [];
    String? ticker = getCurrencyTicker(currency);

    if (ticker != null) {
      List<Quote>? quotes = await getInstrumentQuotes(ticker, from, to);

      if (quotes != null) {
        for (Quote quote in quotes) {
          result.add(Rate(currency: currency,
              date: quote.date,
              open: quote.open,
              low: quote.low,
              high: quote.high,
              close: quote.close));
        }
      }
    }
    return Future.value(result);
  }
}