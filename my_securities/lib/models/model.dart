import 'package:my_securities/models/portfolio.dart';

import '../exchange.dart';

class Model {
  PortfolioList portfolios;
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
