import 'package:my_securities/models/portfolio.dart';

import '../exchange.dart';

class Model {
  PortfolioList portfolios;
}

class Quote {
  DateTime date;
  double open, low, high, close;

  Quote({this.date, this.open, this.low, this.high, this.close});

  factory Quote.fromMap(Map<String, dynamic> json) =>
            Quote(date: DateTime.parse(json["date"]),
              open: json["open"],
              low: json["low"],
              high: json["high"],
              close: json["close"]
            );
}

class Rate {
  Currency currency;
  DateTime date;
  double open, low, high, close;

  Rate({this.currency, this.date, this.open, this.low, this.high, this.close});

  factory Rate.fromMap(Map<String, dynamic> json) =>
      Rate(currency: Currency.values[json["currency_id"] - 1],
          date: DateTime.parse(json["date"]),
          open: json["open"],
          low: json["low"],
          high: json["high"],
          close: json["close"]
      );
}

class Money {
  Currency currency;
  double amount;

  Money({this.currency, this.amount});

  factory Money.fromMap(Map<String, dynamic> json) =>
      Money(currency: Currency.values[json["currency_id"] - 1],
        amount: json["amount"]
      );
}
