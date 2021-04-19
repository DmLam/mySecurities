import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/common/exchange.dart';

class Instrument extends ChangeNotifier{
  int id;
  String isin;
  String ticker;
  String name;
  InstrumentType type;
  Exchange exchange;
  Currency currency;
  Uint8List image;
  String additional;
  int portfolioPercentPlan;
  int quantity;
  double averagePrice;
  double value;
  int operationCount;

  Instrument(this.id, {this.isin = '', this.ticker, this.name, this.currency, this.type,
    this.exchange = Exchange.MCX, this.image, this.additional, this.portfolioPercentPlan, this.quantity = 0,
    this.averagePrice = 0, this.value = 0, this.operationCount = 0});

  Instrument.from(Instrument source):
        this.id = source.id,
        this.isin = source.isin,
        this.ticker = source.ticker,
        this.name = source.name,
        this.currency = source.currency,
        this.type = source.type,
        this.image = source.image,
        this.additional = source.additional,
        this.exchange = source.exchange,
        this.portfolioPercentPlan = source.portfolioPercentPlan,
        this.quantity = source.quantity,
        this.averagePrice = source.averagePrice,
        this.value = source.value,
        this.operationCount = source.operationCount;

  Instrument.empty() {
    this.id = null;
    this.exchange = Exchange.MCX;
    this.quantity = 0;
    this.averagePrice = 0;
    this.value = 0;
    this.operationCount = 0;
  }

  factory Instrument.fromMap(Map<String, dynamic> json) =>
      Instrument(json["id"],
          isin: json["isin"],
          ticker: json["ticker"],
          name: json["name"],
          currency: Currency.values[json["currency_id"] - 1],
          type: InstrumentType.values[json["instrument_type_id"] - 1],
          exchange: Exchange.values[json["exchange_id"] - 1],
          image: json['image'],
          additional: json['additional'],
          portfolioPercentPlan: json['portfolio_percent_plan'],
          quantity: json["quantity"],
          averagePrice: json["avgprice"],
          value: json["value"],
          operationCount: json["operation_count"]);

  double currentValue() => quantity == null ? 0 : quantity * averagePrice;

  double profit(double currentPrice) => quantity == null ? 0 : quantity * (currentPrice - averagePrice);

  String profitString(double currentPrice, {Currency currency}) => (profit(currentPrice) == 0) ? '' : formatCurrency(profit(currentPrice), currency: currency == null ? this.currency : currency);

  Map<String, dynamic> toMap() => {
    "id": id,
    "isin": isin,
    "ticker": ticker,
    "name": name,
    "currency_id": currency.index + 1,
    "instrument_type_id": type.index + 1,
    "exchange_id": exchange.index + 1,
    "image": image,
    "additional": additional,
    "portfolio_percent_plan": portfolioPercentPlan,
    "quantity": quantity,
    "avgprice": averagePrice,
    "value": value,
    "operation_count": operationCount
  };

  Instrument assign(Instrument source) {
    this.id = source.id;
    this.isin = source.isin;
    this.ticker = source.ticker;
    this.name = source.name;
    this.currency = source.currency;
    this.type = source.type;
    this.exchange = source.exchange;
    this.image = source.image;
    this.additional = source.additional;
    this.portfolioPercentPlan = source.portfolioPercentPlan;
    this.quantity = source.quantity;
    this.averagePrice = source.averagePrice;
    this.value = source.value;
    this.operationCount = source.operationCount;

    notifyListeners();

    return source;
  }
}

extension InstrumentExtension on Instrument {

  String valueString({Currency currency}) => value == null ? '' : formatCurrency(value, currency: currency == null ? this.currency : currency);

  String quantityString() => quantity == null ? '' : quantity.toString() + ' ' + S.current.pcs;

  String averagePriceString({Currency currency}) => averagePrice == null ? '' : formatCurrency(averagePrice, currency: currency == null ? this.currency : currency) ;
}

