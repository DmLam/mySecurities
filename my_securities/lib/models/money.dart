import 'package:flutter/cupertino.dart';
import 'package:my_securities/database_list.dart';
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
        portfolio: Model.portfolios.portfolioById(json["portfolio_id"]),
        currency: Currency.values[json["currency_id"] - 1],
        amount: json["amount"]
      );
}

class MoneyList extends DatabaseList<Money> {

  MoneyList(Portfolio portfolio) : super(portfolio);

  Money byCurrency(Currency currency) {
    Money result;

    if (items.length > 0)
      result = items.where((element) => (element.currency == currency)).first;
    return result;
  }

  refresh() async {
    await loadFromDb();
  }

  loadFromDb() async {
    items = await DBProvider.db.getPortfolioMonies(portfolio.id);
  }
}
