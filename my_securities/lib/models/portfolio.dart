import 'package:flutter/material.dart';
import 'package:my_securities/models/operation.dart';
import 'instrument.dart';
import 'package:my_securities/common/database.dart';

class Portfolio extends ChangeNotifier {
  int _id;
  String _name;
  DateTime _startDate;
  InstrumentList _instruments;
  OperationList _operations;

  int get id => _id;
  String get name => _name;
  DateTime get startDate => _startDate;
  InstrumentList get instruments => _instruments;
  OperationList get operations => _operations;

  Portfolio(this._id, this._name, this._startDate) {
    _instruments = InstrumentList(_id);
    _operations = OperationList(_id);
  }

  factory Portfolio.fromMap(Map<String, dynamic> json) =>
    Portfolio(
      json["id"],
      json["name"],
      DateTime.parse(json["start_date"])
    );

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