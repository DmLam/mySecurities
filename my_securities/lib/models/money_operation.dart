import 'package:flutter/foundation.dart';
import 'package:my_securities/database_list.dart';
import '../constants.dart';
import '../database.dart';
import '../exchange.dart';
import 'model.dart';
import 'money.dart';
import 'operation.dart';
import 'portfolio.dart';

enum MoneyOperationType {deposit, withdraw, buy, sell, commission} // buy, sell and commission is only for non-money operations (i.e. buying and selling securities)

extension MoneyOperationTypeExtension on MoneyOperationType {
  int get id => index + 1;

  String get name => MONEY_OPERATION_TYPE_NAMES[this.index];

  bool get income => this == MoneyOperationType.deposit || this == MoneyOperationType.sell;
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
  String comment;

  double get amount => _amount;
  set amount(double value) {
    if (_amount != value) {
      Money money = portfolio.monies.byCurrency(currency);

      if (money != null)
        money.amount += value - _amount;
      _amount = value;
    }
  }

  MoneyOperation({this.id, this.portfolio, this.operation, this.currency, this.date, this.type, amount, this.comment}):
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
        amount: json["amount"],
        comment: json["comment"]
    );
  }

  MoneyOperation.empty({@required Portfolio portfolio}) :
    this.portfolio = portfolio,
    date = null,
    type = MoneyOperationType.deposit,
    _amount = 0;


  MoneyOperation.from(MoneyOperation op) :
    currency = op.currency,
    portfolio = op.portfolio,
    operation = op.operation,
    date = op.date,
    type = op.type,
    _amount = op.amount,
    comment = op.comment;

  assign(MoneyOperation op) {
    currency = op.currency;
    portfolio = op.portfolio;
    operation = op.operation;
    date = op.date;
    type = op.type;
    _amount = op.amount;
    comment = op.comment;
  }

  Future<int> add() async {
    id = await DBProvider.db.addMoneyOperation(this);

    portfolio.refresh(); // changes nothing, just notify listeners

    return Future.value(id);
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
    await DBProvider.db.deleteMoneyOperation(this);

    await portfolio.refresh();
  }
}

class MoneyOperationList extends DatabaseList<MoneyOperation>{

  MoneyOperationList(Portfolio portfolio): super(portfolio);

  List<MoneyOperation> byCurrency(Currency currency) =>
      length == 0 ? null :
      items.where((item) => currency == null || item.currency == currency).toList();

  loadFromDb() async {
    items = await DBProvider.db.getPortfolioMoneyOperations(portfolio.id);
  }

  List<MoneyOperation> byOperationId(int id) {
    if (length == null || id == null)
      return null;

    return
      items.where((item) => item.operation?.id == id).toList();
  }

}

MoneyOperationType operationTypeToMoneyOperationType(OperationType op) {
  return op == OperationType.buy ? MoneyOperationType.buy :
  op == OperationType.sell ? MoneyOperationType.sell : null;
}
