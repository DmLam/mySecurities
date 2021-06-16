import 'package:flutter/foundation.dart';
import '../constants.dart';
import '../database.dart';
import 'model.dart';
import 'package:my_securities/models/portfolio.dart';
import '../exchange.dart';
import 'money.dart';


enum MoneyOperationType {deposit, withdraw, buy, sell}  // buy and sell is only for non-money operations (i.e. buying and selling securities)

extension MoneyOperationTypeExtension on MoneyOperationType {
  String name() {
    return MONEY_OPERATION_TYPE_NAMES[this.index];
  }
}
class MoneyOperation extends ChangeNotifier {
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
          portfolio: Model.portfolios.portfolioById(json["portfolio_id"]),
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
    int result = await portfolio.moneyOperations._add(this);

    notifyListeners();
    portfolio.update(); // changes nothing, just notify listeners

    return Future.value(result);
  }

  Future<bool> update() async {
    bool result;

    if (id != null) {
      await DBProvider.db.updateMoneyOperation(this);
      notifyListeners();
      portfolio.update(); // changes nothing, just notify listeners
      result = true;
    }

    return Future.value(result);
  }

  delete() async {
    await portfolio.moneyOperations._delete(this);

    notifyListeners();
    portfolio.update(); // changes nothing, just notify listeners
  }
}

class MoneyOperationList {
  MoneyList _monies;
  List<MoneyOperation> _items;

  MoneyOperationList(this._monies) {
    _loadFromDb();
  }

  List<MoneyOperation> get operations => [..._items];

  List<MoneyOperation> byCurrency(Currency currency) =>
    _items.where((item) => currency == null || item.currency == currency).toList();

  _loadFromDb() async {
    _items = await DBProvider.db.getPortfolioMoneyOperations(_monies.portfolio.id);
  }

  Future<int> _add(MoneyOperation op) async {
    int result = await DBProvider.db.addMoneyOperation(op);
    await _loadFromDb();
    await _monies.refresh();  // refresh list of monies in the portfolio
    _monies.portfolio.update(); // just notify portfolio that the list of money operations has been changed
    return Future.value(result);
  }

  _delete(MoneyOperation op) async {
    await DBProvider.db.deleteMoneyOperation(op);
    await _loadFromDb();
    await _monies.refresh();  // refresh list of monies in the portfolio
    _monies.portfolio.update(); // just notify portfolio that the list of money operations has been changed
  }
}