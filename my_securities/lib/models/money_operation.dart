import 'package:flutter/foundation.dart';
import '../database.dart';
import 'model.dart';
import 'package:my_securities/models/portfolio.dart';
import '../exchange.dart';
import 'money.dart';


enum MoneyOperationType {deposit, withdraw, buy, sell}  // buy and sell is only for non-money operations (i.e. buying and selling securities)

class MoneyOperation {
  int id;
  Portfolio portfolio;
  Currency currency;
  DateTime date;
  MoneyOperationType type;
  double amount;

  MoneyOperation({this.id, this.portfolio, this.currency, this.date, this.type, this.amount});

  factory MoneyOperation.fromMap(Map<String, dynamic> json) =>
      MoneyOperation(
          id: json["id"],
          portfolio: Model.portfolios().portfolioById(json["portfolio_id"]),
          currency: Currency.values[json["currency_id"] - 1],
          date: DateTime.parse(json["date"]),
          type: MoneyOperationType.values[json["type"] - 1],
          amount: json["amount"]
      );

  MoneyOperation.empty({@required Portfolio portfolio}) {
    DateTime now = DateTime.now();

    this.portfolio = portfolio;
    type = MoneyOperationType.deposit;
    date = DateTime(now.year, now.month, now.day);
    amount = 0;
  }

  MoneyOperation.from(MoneyOperation op) :
    currency = op.currency,
    portfolio = op.portfolio,
    date = op.date,
    type = op.type,
    amount = op.amount;

  assign(MoneyOperation op) {
    currency = op.currency;
    portfolio = op.portfolio;
    date = op.date;
    type = op.type;
    amount = op.amount;
  }

  Future<int> add() async {
    int result = await portfolio.monies._add(this);

    portfolio.notifyListeners();

    return Future.value(result);
  }
}

class MoneyList {
  Portfolio _portfolio;
  List<Money> _items;

  MoneyList(this._portfolio) {
    _loadFromDb();
  }

  List<Money> get monies => [..._items];

  _loadFromDb() async {
    _items = await DBProvider.db.getPortfolioMonies(_portfolio.id);
  }

  Future<int> _add(MoneyOperation moneyOperation) async {
    int result = await DBProvider.db.addMoneyOperation(moneyOperation);
    await _loadFromDb();
    return Future.value(result);
  }

  _delete(MoneyOperation moneyOperation) async {
    await DBProvider.db.deleteMoneyOperation(moneyOperation.id);
    await _loadFromDb();
  }


}