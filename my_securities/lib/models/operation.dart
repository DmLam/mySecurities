import 'package:flutter/foundation.dart';
import 'package:my_securities/exchange.dart';
import '../constants.dart';
import '../database.dart';
import 'money_operation.dart';
import 'portfolio.dart';
import 'instrument.dart';
import 'model.dart';
import 'money.dart';

enum OperationType {buy, sell}

extension OperationTypeExtension on OperationType {
  int get id => index + 1;

  String get name => OPERATION_TYPE_NAMES[this.index];
}

class NoCurrencyException implements Exception {}
class NotEnoughMoneyException implements Exception {}

class Operation extends ChangeNotifier{
  int id;
  Portfolio portfolio;
  Instrument instrument;
  DateTime date;
  OperationType type;
  int quantity;
  double price;
  double commission;

  double get value => (type == OperationType.buy ? 1 : -1) * (price * quantity * 10000).roundToDouble() / 10000;

  String valueString() => value == null ? '' : formatCurrency(value);

  String priceString() => price == null ? '' : formatCurrency(price);

  Operation({@required int id, @required Portfolio portfolio, Instrument instrument,
      @required DateTime date, @required OperationType type, @required int quantity, @required double price,
      double commission = 0, MoneyOperation moneyOperation}):
    this.id = id,
    this.portfolio = portfolio,
    this.instrument = instrument,
    this.date = date,
    this.type = type,
    this.quantity = quantity,
    this.price = price,
    this.commission = commission;

  Operation.empty({@required Portfolio portfolio, Instrument instrument}) {
    DateTime now = DateTime.now();

    this.id = null;
    this.portfolio = portfolio;
    this.instrument = instrument;
    this.date = DateTime(now.year, now.month, now.day);
    this.type = OperationType.buy;
    this.quantity = 0;
    this.price = 0;
    this.commission = 0;
  }

  assign(Operation source) {
    id = source.id;
    portfolio = source.portfolio;
    instrument = source.instrument;
    date = source.date;
    type = source.type;
    quantity = source.quantity;
    price = source.price;
    commission = source.commission;

    notifyListeners();
  }

  factory Operation.fromMap(Map<String, dynamic> json) =>
      Operation(id: json["id"],
          portfolio: Model.portfolios.portfolioById(json["portfolio_id"]),
          instrument: Model.portfolios.portfolioById(json["portfolio_id"]).instrumentById(json["instrument_id"]),
          date: DateTime.parse(json["date"]),
          type: OperationType.values[json["type"]],
          quantity: json["quantity"],
          price: json["price"],
          commission: json["commission"]
          // todo - load reference money operation if present
      );

  Future<int> add(bool createMoneyOperation) async {
    MoneyOperation moneyOp;

    if (createMoneyOperation) {
      // check there is enough money for the operation
      Money m = portfolio.monies.byCurrency(instrument.currency);
      if (m == null)
        throw NoCurrencyException();
      else
      if (m.amount < value)
        throw NotEnoughMoneyException();

      moneyOp = MoneyOperation(portfolio: portfolio,
          date: date,
          currency: instrument.currency,
          type: operationTypeToMoneyOperationType(type),
          amount: value + commission,
          operation: this);
    }

    await DBProvider.db.addOperation(this, moneyOperation: moneyOp);
    await portfolio.refresh(); // reload instruments, money and operations from db
//    instrument.notifyListeners();

    return Future.value(id);
  }

  Future<bool> update() async {
    bool result = false;

    if (id != null) {
      await DBProvider.db.updateOperation(this);

      MoneyOperation mop = portfolio.moneyOperations.byOperationId(id);
      if (mop != null) {
        mop.currency = instrument.currency;
        mop.type = operationTypeToMoneyOperationType(this.type);
        mop.date = date;
        mop.amount = value + commission;
        mop.update();
      }
      portfolio.refresh(); // reload instruments, money and operations from db
//      instrument.notifyListeners();

      result = true;
    }
    return Future.value(result);
  }

  delete() async {
    await DBProvider.db.deleteOperation(this);
    MoneyOperation mop = portfolio.moneyOperations.byOperationId(id);
    if (mop != null)
      mop.delete();

    await portfolio.refresh(); // reload instruments, money and operations from db
//    instrument.notifyListeners();
  }
}

class OperationList {
  List<Operation> _items = [];
  Portfolio _portfolio;

  OperationList(this._portfolio) {
    _loadFromDb();
  }

  List<Operation> get operations => [..._items];

  List<Operation> byInstrument(Instrument instrument) =>
    _items.where((op) => instrument == null || op.instrument == instrument).toList();

  Operation byId(int id) => id == null ? null : _items.where((item) => item.id == id).toList().first;

  _loadFromDb() async {
    _items = await DBProvider.db.getPortfolioOperations(_portfolio.id);
  }
}