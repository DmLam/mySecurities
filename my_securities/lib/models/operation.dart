import 'package:flutter/foundation.dart';
import 'package:my_securities/database_list.dart';
import 'package:my_securities/exchange.dart';
import 'package:my_securities/generated/l10n.dart';
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
  OperationType _type;
  int _quantity;
  double _price;
  double _commission;
  String comment;

  OperationType get type => _type;
  int get quantity => _quantity;
  double get price => _price;
  double get commission => _commission;
  set quantity(int newQuantity) {
    checkMoneyAmount(_type, newQuantity, _price, _commission);
    _quantity = newQuantity;
  }
  set price(double newPrice) {
    checkMoneyAmount(_type, _quantity, newPrice, _commission);
    _price = newPrice;
  }
  set type(OperationType newType) {
    checkMoneyAmount(newType, _quantity, _price, _commission);
    _type = newType;
  }
  set commission(double newCommission) {
    checkMoneyAmount(_type, _quantity, _price, newCommission);
    _commission = newCommission;
  }

  double _getOperationValue(OperationType type, int quantity, double price, double commission) =>
      (type == OperationType.buy ? -1 : 1) * ((price * quantity) * 10000).roundToDouble() / 10000;

  double get value => _getOperationValue(type, quantity, price, 0);

  String valueString() => value == null ? '' : formatCurrency(value);

  String priceString() => price == null ? '' : formatCurrency(price);

  checkMoneyAmount(OperationType newType, int newQuantity, double newPrice, double newCommission) {
    double newValue = _getOperationValue(newType, newQuantity, newPrice, newCommission);
    Money m = portfolio.monies.byCurrency(instrument.currency);

    // check there is enough money for the operation
    if (m == null)
      throw NoCurrencyException();
    else
    if (m.amount - value + newValue < 0)
      throw NotEnoughMoneyException();
  }

  Operation({@required int id, @required Portfolio portfolio, Instrument instrument,
      @required DateTime date, @required OperationType type, @required int quantity, @required double price,
      double commission = 0, String comment}):
    this.id = id,
    this.portfolio = portfolio,
    this.instrument = instrument,
    this.date = date,
    this._type = type,
    this._quantity = quantity,
    this._price = price,
    this._commission = commission,
    this.comment = comment;

  Operation.empty({@required Portfolio portfolio, Instrument instrument}) {
    this.id = null;
    this.portfolio = portfolio;
    this.instrument = instrument;
    this.date = null;
    this._type = OperationType.buy;
    this._quantity = 0;
    this._price = 0;
    this._commission = 0;
    this.comment = null;
  }

  assign(Operation source) {
    id = source.id;
    portfolio = source.portfolio;
    instrument = source.instrument;
    date = source.date;
    _type = source.type;
    _quantity = source.quantity;
    _price = source.price;
    _commission = source.commission;
    comment = source.comment;

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
          commission: json["commission"],
          comment: json["comment"]
      );

  String dealOperationComment() {
    return "${type.name} $quantity ${instrument.name}";
  }

  String commissionOperationComment() {
    return S.current.operationEditDialog_commission;
  }

  Future<int> add(bool createMoneyOperation) async {
    MoneyOperation dealOp, commissionOp;

    if (createMoneyOperation)
      dealOp = MoneyOperation(portfolio: portfolio,
          date: date,
          currency: instrument.currency,
          type: operationTypeToMoneyOperationType(type),
          amount: value,
          operation: this,
          comment: dealOperationComment());
      if (commission != 0)
        commissionOp = MoneyOperation(portfolio: portfolio,
            date: date,
            currency: instrument.currency,
            type: MoneyOperationType.commission,
            amount: -commission,
            operation: this,
            comment: commissionOperationComment());

    await DBProvider.db.addOperation(this, moneyOperation: dealOp, commissionOperation: commissionOp);
    await portfolio.refresh(); // reload instruments, money and operations from db

    return Future.value(id);
  }

  Future<bool> update(bool createMoneyOperation) async {
    bool result = false;
    bool wasCommissionOperation = false;

    if (id != null) {
      await DBProvider.db.updateOperation(this);

      List<MoneyOperation> mops = portfolio.moneyOperations.byOperationId(id);
      if (mops.isNotEmpty) {
        if (!createMoneyOperation)
          mops.forEach((mop) {mop.delete();});
        else {
          for (MoneyOperation mop in mops) {
            if (mop.type == MoneyOperationType.commission) {
              wasCommissionOperation = true;
              mop.currency = instrument.currency;
              mop.type = MoneyOperationType.commission;
              mop.date = date;
              mop.amount = -commission;
              mop.update();
            }
            else {
              if (commission == 0)
                mop.delete();
              else {
                mop.currency = instrument.currency;
                mop.type = operationTypeToMoneyOperationType(this.type);
                mop.date = date;
                mop.amount = -commission;
                mop.update();
              }
            }
          }
          if (createMoneyOperation && !wasCommissionOperation && commission != 0) {
            MoneyOperation commissionOp = MoneyOperation(portfolio: portfolio,
                date: date,
                currency: instrument.currency,
                type: MoneyOperationType.commission,
                amount: -commission,
                operation: this,
                comment: commissionOperationComment());
            commissionOp.add();
          }
        }
      }
      else { // mop == null
        if (createMoneyOperation) {
          MoneyOperation mop = MoneyOperation(portfolio: portfolio,
              date: date,
              currency: instrument.currency,
              type: operationTypeToMoneyOperationType(type),
              amount: value + commission,
              operation: this);

          mop.add();
        }
      }

      await portfolio.refresh(); // reload instruments, money and operations from db

      result = true;
    }
    return Future.value(result);
  }

  delete() async {
    List<MoneyOperation> mops = portfolio.moneyOperations.byOperationId(id);

    await DBProvider.db.deleteOperation(this);
    if (mops != null)
      mops.forEach((element) {element.delete();});
    else
      await portfolio.refresh(); // reload instruments, money and operations from db
  }
}

extension OperationExtension on Operation {

}

class OperationList extends DatabaseList<Operation> {

  OperationList(Portfolio portfolio) : super(portfolio);

  List<Operation> byInstrument(Instrument instrument) =>
    items.where((op) => instrument == null || op.instrument == instrument).toList();

  Operation byId(int id) => id == null ? null : items.firstWhere((item) => item.id == id, orElse: () => null);

  loadFromDb() async {
    items = await DBProvider.db.getPortfolioOperations(portfolio.id);
  }
}