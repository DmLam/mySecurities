import 'package:flutter/material.dart';
import 'package:my_securities/models/operation.dart';
import 'instrument.dart';
import 'package:my_securities/database.dart';

class Portfolio extends ChangeNotifier {
  int _id;
  String _name;
  DateTime _startDate;

  InstrumentList _instruments;
  OperationList _operations;

  int get id => _id;
  String get name => _name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }
  DateTime get startDate => _startDate;

  InstrumentList get instruments => _instruments;
  OperationList get operations => _operations;

  Portfolio(this._id, this._name, this._startDate) {
    _instruments = InstrumentList(_id);
    _operations = OperationList(_id);
  }

  Portfolio.empty() :
    _id = null,
    _name = "",
    _startDate = null;

  factory Portfolio.fromMap(Map<String, dynamic> json) =>
    Portfolio(
      json["id"],
      json["name"],
      json["start_date"] == null ? null : DateTime.parse(json["start_date"])
    );

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
  List<Portfolio> _portfolios;
  Future _ready;

  Future get ready => _ready;

  List<Portfolio> get portfolios => [..._portfolios];

  PortfolioList() {
    _ready = _init();
  }

  Future _init() async{
    final data = await DBProvider.db.getPortfolios();
    _portfolios = data;
  }

  Future<bool> add(Portfolio portfolio) async {
    bool result = await DBProvider.db.addPortfolio(portfolio);

    if (result){
      _portfolios = await DBProvider.db.getPortfolios();
      result = true;
    }

    notifyListeners();

    return Future.value(result);
  }

  Future<bool> delete(Portfolio portfolio) async {
    bool result = await DBProvider.db.deletePortfolio(portfolio);

    if (result){
      _portfolios = await DBProvider.db.getPortfolios();
      notifyListeners();
    }

    return Future.value(result);
  }
}