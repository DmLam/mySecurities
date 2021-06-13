import 'package:flutter/cupertino.dart';
import 'package:my_securities/models/portfolio.dart';

import '../database.dart';
import '../exchange.dart';
import 'model.dart';

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

class MoneyList {
  Portfolio _portfolio;
  List<Money> _items;

  MoneyList(this._portfolio) {
    _loadFromDb();
  }

  Money byCurrency(Currency currency) {
    return _items.where((element) => (element.currency == currency)).first;
  }

  List<Money> get monies => [..._items];

  _loadFromDb() async {
    _items = await DBProvider.db.getPortfolioMonies(_portfolio.id);
  }
}
