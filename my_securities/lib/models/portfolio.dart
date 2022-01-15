import 'package:flutter/material.dart';
import 'package:my_securities/common/types.dart';
import 'package:my_securities/common/utils.dart';
import 'package:my_securities/models/operation.dart';
import 'instrument.dart';
import 'package:my_securities/database.dart';

import 'model.dart';
import 'money.dart';
import 'money_operation.dart';

class Portfolio extends ChangeNotifier {
  PortfolioList? _owner;
  int? _id;
  String name;
  bool _visible;
  DateTime _startDate;
  double? commission;

  late final InstrumentList _instruments;
  late final OperationList _operations;
  late final MoneyList _monies;
  late final MoneyOperationList _moneyOperations;

  int? get id => _id;
  bool get visible => _visible;
  DateTime get startDate => _startDate;

  InstrumentList get instruments => _instruments;
  OperationList get operations => _operations;
  MoneyList get monies => _monies;
  MoneyOperationList get moneyOperations => _moneyOperations;

  Portfolio(this._id, this.name, this._visible, this._startDate, this.commission)
  {
    _loadFromDb();
  }

  _loadFromDb() async {
    _instruments = InstrumentList(this);
    _operations = OperationList(this);
    _monies = MoneyList(this);
    _moneyOperations = MoneyOperationList(this);

    await _instruments.ready;
    await _operations.ready;
    await _monies.ready;
    await _moneyOperations.ready;
  }

  refresh() async {
    await _loadFromDb();
    notifyListeners();
  }

  Portfolio.from(Portfolio portfolio) :
    _owner = portfolio._owner,
    _id = portfolio._id,
    name = portfolio.name,
    _visible = portfolio._visible,
    _startDate = portfolio._startDate,
    commission = portfolio.commission;

  Portfolio.empty() :
    _owner = null,
    _id = null,
    name = "",
    _visible = true,
    _startDate = currentDate(),
    commission = null;

  factory Portfolio.fromMap(Map<String, dynamic> json) =>
    Portfolio(
      json["id"],
      json["name"],
      json["visible"] == 1,
      DateTime.parse(json["start_date"]),
      json["commission"]);

  assign(Portfolio source) {
    this._id = source._id;
    this._owner = source._owner;
    this.name = source.name;
    this._visible = source._visible;
    this._startDate = source._startDate;
    this.commission = source.commission;

    notifyListeners();
  }

  Future<int> add(Portfolio portfolio) async {
    return Future.value(await Model.portfolios._add(portfolio));
  }

  Future<bool> update({String? name, bool? visible, DateTime? startDate, double? commission}) async {
    bool doUpdate = false;
    bool result = false;

    if (this.name != name && name != null) {
      this.name = name;
      doUpdate = true;
    }
    if (visible != _visible && visible != null) {
      _visible = visible;
      doUpdate = true;
    }
    if (startDate != _startDate && startDate != null) {
      _startDate = startDate;
      doUpdate = true;
    }
    if (this.commission != commission) {
      this.commission = commission;
      doUpdate = true;
    }
    if (doUpdate)
      result = await DBProvider.db.updatePortfolio(this);

    notifyListeners();

    return Future.value(result);
  }

  Future<bool> delete() async {
    return Future.value(await Model.portfolios._delete(this));
  }
}

class PortfolioList extends ChangeNotifier {
  List<Portfolio> _items = [];
  late final Future _ready;

  Future get ready => _ready;

  List<Portfolio> get portfolios => [..._items];
  List<Portfolio> get visiblePortfolios => [..._items.where((item) => item.visible)];

  PortfolioList() {
    _ready = _init();
  }

  Portfolio portfolioById(int id) {
    Portfolio? result;

    for(Portfolio item in _items) {
      if (item.id == id) {
        result = item;
        break;
      }
    }

    if (result == null)
      throw InternalException("Portfolio [$id] not found");

    return result;
  }

  _loadFromDb() async {
    _items = await DBProvider.db.getPortfolios();
    _items.forEach((element) => element._owner = this);
  }

  Future _init() async{
    await _loadFromDb();
    return Future.value(null);
  }

  Future<int?> _add(Portfolio portfolio) async {
    int? result = await DBProvider.db.addPortfolio(portfolio);

    await _loadFromDb();
    notifyListeners();

    return Future.value(result);
  }

  Future<bool> _delete(Portfolio portfolio) async {
    bool result = await DBProvider.db.deletePortfolio(portfolio);

    if (result){
      await _loadFromDb();
      notifyListeners();
    }

    return Future.value(result);
  }
}