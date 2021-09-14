import 'package:flutter/foundation.dart';
import '../constants.dart';
import '../database.dart';
import '../exchange.dart';
import 'model.dart';
import 'money.dart';
import 'operation.dart';
import 'portfolio.dart';


enum MoneyOperationType {deposit, withdraw, buy, sell}  // buy and sell is only for non-money operations (i.e. buying and selling securities)

extension MoneyOperationTypeExtension on MoneyOperationType {
  int get id => index + 1;

  String get name => MONEY_OPERATION_TYPE_NAMES[this.index];
}

// see comment to currencyById
MoneyOperationType moneyOperationTypeById(int id) => MoneyOperationType.values[id - 1];

class MoneyOperation extends ChangeNotifier {
  int id;
  Portfolio portfolio;
  Operation operation;
  Currency currency;
  DateTime date;
  MoneyOperationType type;
  double _amount;

  double get amount => _amount;
  set amount(double value) {
    if (_amount != value) {
      portfolio.monies.byCurrency(currency).amount += value - _amount;
      _amount = value;
    }
  }

  MoneyOperation({this.id, this.portfolio, this.operation, this.currency, this.date, this.type, amount}):
    _amount = amount;

  factory MoneyOperation.fromMap(Map<String, dynamic> json) {
    Portfolio portfolio = Model.portfolios.portfolioById(json["portfolio_id"]);

    return MoneyOperation(
        id: json["id"],
        portfolio: portfolio,
        operation: portfolio.operations.byId(json["operation_id"]),
        currency: currencyById(json["currency_id"]),
        date: DateTime.parse(json["date"]),
        type: moneyOperationTypeById(json["type"]),
        amount: json["amount"]
    );
  }

  MoneyOperation.empty({@required Portfolio portfolio}) {
    DateTime now = DateTime.now();

    this.portfolio = portfolio;
    type = MoneyOperationType.deposit;
    date = DateTime(now.year, now.month, now.day);
  }

  MoneyOperation.from(MoneyOperation op) :
    currency = op.currency,
    portfolio = op.portfolio,
    operation = op.operation,
    date = op.date,
    type = op.type,
    _amount = op.amount;

  assign(MoneyOperation op) {
    currency = op.currency;
    portfolio = op.portfolio;
    operation = op.operation;
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

  refresh() {
    _loadFromDb();
  }

  MoneyOperation byId(int id) => _items.where((item) => item.operation.id == id).toList().first;

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

MoneyOperationType operationTypeToMoneyOperationType(OperationType op) {
  return op == OperationType.buy ? MoneyOperationType.buy :
  op == OperationType.sell ? MoneyOperationType.sell : null;
}
