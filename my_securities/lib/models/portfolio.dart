import 'package:flutter/material.dart';

import 'instrument.dart';
import 'package:my_securities/common/database.dart';

class Portfolio {
  int _id;
  String _name;
  List<Instrument> instruments = [];

  int get id => _id;
  String get name => _name;
  Instrument operator [](int index) => instruments[index];
  int get length => instruments.length;

  Portfolio(this._id, this._name);

  factory Portfolio.fromMap(Map<String, dynamic> json) =>
    Portfolio(json["id"],
              json["name"]);
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