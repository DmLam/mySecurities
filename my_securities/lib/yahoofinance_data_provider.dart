import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'exchange.dart';
import 'models/instrument.dart';
import 'models/quote.dart';
import 'models/rate.dart';
import 'stock_exchange_interface.dart';

class YahooFinanceDataProvider implements StockExchangeProvider {
  static const String _QUERY_URI = 'query1.finance.yahoo.com';
  static const String _SEARCH = '/v1/finance/search';

// https://query1.finance.yahoo.com/v1/finance/search?q=t&lang=en-US&region=US&quotesCount=6&newsCount=4&enableFuzzyQuery=false&quotesQueryId=tss_match_phrase_query&multiQuoteQueryId=multi_quote_single_token_query&newsQueryId=news_cie_vespa&enableCb=true&enableNavLinks=true&enableEnhancedTrivialQuery=true

  @override
  Future<Uint8List?> getInstrumentImage(Instrument instrument) async {
    return null;
  }

  @override
  Future<List?> search({required String ticker}) async {
    Map<String, dynamic> r;
    http.Response response;
    List? result;
    Uri uri = Uri.https(_QUERY_URI, _SEARCH,
        {
          'q': ticker,
          'quotesCount': '6',
          'newsCount': '0',
//          'enableFuzzyQuery': 'false',
//          'quotesQueryId': 'tss_match_phrase_query',
//          'multiQuoteQueryId': 'multi_quote_single_token_query',
//          'newsQueryId': 'news_cie_vespa',
//          'enableCb': 'true',
//          'enableNavLinks': 'false',
//          'enableEnhancedTrivialQuery': 'true'
        });

    response = await http.get(uri);
    if (response.statusCode != 400) {
      if (response.statusCode != 200)
        throw Exception("Error searching instrument");
      result = [];

      r = jsonDecode(response.body);
      r = r['quotes'];
      for (var quote in r.values) {
        String ticker, name, shortName;
        Exchange exchange;
        InstrumentType? type;

        ticker = quote['symbol'];
        exchange = exchangeFromName(quote['exchange']);
        shortName = quote['shortname'];
        name = quote['longname'];
        switch(quote['quoteType']) {
          case 'ETF':
            type = InstrumentType.etf;
            break;
          case 'EQUITY':
            type = null;
            break;
          case 'INDEX':
            type = InstrumentType.stockIndex;
            break;
          default:
            break;
        }

        result.add(
            SearchItem(
                exchange: exchange,
                isin: '', // НЕЛЬЗЯ ТАК, но будем разбираться если вдруг задействуем Yahoo
                ticker: ticker,
                name: name,
                shortName: shortName,
                currency: Currency.RUB, // НЕЛЬЗЯ ТАК, но будем разбираться если вдруг задействуем Yahoo
                type: type
            ));
        }
      }

    return Future.value(result);
  }

  Future<double?> getInstrumentLastQuote(String ticker) => Future.value(null);
  Future<double?> getInstrumentPrice(String ticker, {DateTime? date}) => Future.value(null);
  Future<List<Quote>> getInstrumentQuotes(String ticker, DateTime from, DateTime to) => Future.value([]);
  Future<double> convert(double value, Currency from, Currency to) => Future.value(null);
  String? getCurrencyTicker(Currency currency) => null;
  Future<double?> getCurrencyRate(Currency from, Currency to, {DateTime? datetime}) => Future.value(null);
  Future<List<Rate>> getCurrencyRates(Currency currency, DateTime from, DateTime? to) => Future.value([]);
}