import 'package:flutter/cupertino.dart';
import 'package:my_securities/database.dart';
import 'package:my_securities/models/portfolio.dart';

import '../exchange.dart';
import 'model.dart';
import 'money_operation.dart';

class Money extends ChangeNotifier {
  Portfolio portfolio;
  Currency currency;
  double amount;

  Money({this.portfolio, this.currency, this.amount});

  factory Money.fromMap(Map<String, dynamic> json) =>
      Money(
        portfolio: Model.portfolios().portfolioById(json["portfolio_id"]),
        currency: Currency.values[json["currency_id"] - 1],
        amount: json["amount"]
      );
}

