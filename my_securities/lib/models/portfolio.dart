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
    DBProvider.db.updatePortfolio(this);
    _owner.notifyListeners();
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

  Portfolio.empty(PortfolioList owner) :
    _owner = owner,
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

  Instrument instrumentById(int id) => instruments.instrumentById(id);

  Future<bool> update() async {
    bool result = await DBProvider.db.updatePortfolio(this);

    if (result){
      result = true;
    }

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

  _getPortfolios() async {
    _items = await DBProvider.db.getPortfolios();
    _items.forEach((element) {element._owner = this;});
  }

  Future _init() async{
    await _getPortfolios();
  }

  Future<bool> add(Portfolio portfolio) async {
    bool result = await DBProvider.db.addPortfolio(portfolio);

    if (result){
      await _getPortfolios();
      notifyListeners();
    }

    return Future.value(result);
  }

  Future<bool> delete(Portfolio portfolio) async {
    bool result = await DBProvider.db.deletePortfolio(portfolio);

    if (result){
      await _getPortfolios();
      notifyListeners();
    }

    return Future.value(result);
  }
}