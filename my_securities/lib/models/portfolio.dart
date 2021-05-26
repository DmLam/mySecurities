import 'package:flutter/material.dart';
import 'package:my_securities/models/operation.dart';
import 'instrument.dart';
import 'package:my_securities/database.dart';

class Portfolio extends ChangeNotifier {
  PortfolioList _owner;
  int _id;
  String _name;
  bool _visible;
  DateTime _startDate;

  InstrumentList _instruments;
  OperationList _operations;

  int get id => _id;
  String get name => _name;
  set name(String name) {
    _name = name;
    DBProvider.db.updatePortfolio(this);
    notifyListeners();
  }
  bool get visible => _visible;
  set visible(bool visible) {
    _visible = visible;
  }
  DateTime get startDate => _startDate;

  InstrumentList get instruments => _instruments;
  OperationList get operations => _operations;

  Portfolio(this._id, this._name, this._visible, this._startDate) {
    _instruments = InstrumentList(this);
    _operations = OperationList(this);
  }

  Portfolio.from(Portfolio portfolio) :
    _owner = portfolio._owner,
    _id = portfolio._id,
    _name = portfolio._name,
    _visible = portfolio._visible,
    _startDate = portfolio._startDate;

  Portfolio.empty() :
    _owner = null,
    _id = null,
    _name = "",
    _visible = true,
    _startDate = null;

  factory Portfolio.fromMap(Map<String, dynamic> json) =>
    Portfolio(
      json["id"],
      json["name"],
      json["visible"] == 1,
      json["start_date"] == null ? null : DateTime.parse(json["start_date"])
    );

  assign(Portfolio source) {
    this._id = source._id;
    this._owner = source._owner;
    this._name = source._name;
    this._visible = source._visible;
    this._startDate = source._startDate;

    notifyListeners();
  }

  Instrument instrumentById(int id) => instruments.instrumentById(id);

  Future<bool> update() async {
    bool result = await DBProvider.db.updatePortfolio(this);

    notifyListeners();

    return Future.value(result);
  }
}

class PortfolioList extends ChangeNotifier {
  List<Portfolio> _items;
  Future _ready;

  Future get ready => _ready;

  List<Portfolio> get portfolios => [..._items];
  List<Portfolio> get visiblePortfolios => [..._items.where((item) => item.visible)];

  PortfolioList() {
    _ready = _init();
  }

  Portfolio portfolioById(int id) {
    Portfolio result;

    for(Portfolio item in _items) {
      if (item.id == id) {
        result = item;
        break;
      }
    }
    return result;
  }

  _getPortfoliosFromDB() async {
    _items = await DBProvider.db.getPortfolios();
    _items.forEach((element) {element._owner = this;});
  }

  Future _init() async{
    await _getPortfoliosFromDB();
  }

  Future<bool> add(Portfolio portfolio) async {
    bool result = await DBProvider.db.addPortfolio(portfolio);

    if (result){
      await _getPortfoliosFromDB();
      notifyListeners();
    }

    return Future.value(result);
  }

  Future<bool> delete(Portfolio portfolio) async {
    bool result = await DBProvider.db.deletePortfolio(portfolio);

    if (result){
      await _getPortfoliosFromDB();
      notifyListeners();
    }

    return Future.value(result);
  }
}