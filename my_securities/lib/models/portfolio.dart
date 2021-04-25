import 'package:flutter/material.dart';
import 'package:my_securities/models/operation.dart';
import 'instrument.dart';
import 'package:my_securities/common/database.dart';

class Portfolio extends ChangeNotifier {
  int _id;
  String _name;
  DateTime _startDate;
  List<Instrument> _instruments = [];
  List<Operation> _operations = [];

  int get id => _id;
  String get name => _name;
  DateTime get startDate => _startDate;
  int get instrumentCount => _instruments.length;
  Instrument instrument(int index) => _instruments[index];
  int get operationCount => _operations.length;
  Operation operation(int index) => _operations[index];

  Portfolio(this._id, this._name, this._startDate) {
    _loadInstruments();
    _loadOperations();
  }

  factory Portfolio.fromMap(Map<String, dynamic> json) =>
    Portfolio(
      json["id"],
      json["name"],
      DateTime.parse(json["start_date"])
    );

  void _loadInstruments() async {
    _instruments = await DBProvider.db.getPortfolioInstruments(_id);
    notifyListeners();
  }

  void _loadOperations() async {
    _operations = await DBProvider.db.getPortfolioOperations(_id);
    notifyListeners();
  }
}

class Portfolios extends ChangeNotifier {
  List<Portfolio> items = [];

  int get length => items.length;

  Portfolio operator [](int index) => items[index];

  Future<void> _init() async{
    items = await DBProvider.db.getPortfolios();
    notifyListeners();
  }

  Portfolios()  {
    _init();
  }
}