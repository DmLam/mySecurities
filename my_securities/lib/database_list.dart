import 'dart:collection';
import 'package:meta/meta.dart';
import 'package:my_securities/models/portfolio.dart';

// List class with property 'ready' signalling that list values have been loaded from db
abstract class DatabaseList<E> extends ListBase<E> {
  Portfolio _portfolio;
  @protected List<E> items = [];
  late final Future _ready;

  DatabaseList(this._portfolio) {
    _ready = _init();
  }

  Portfolio get portfolio => _portfolio;

  int get length => items.length;
  set length(int newLength) {throw Exception("AsyncList is unextendable");}

  E operator [](int index) => items[index];
  operator []=(int index, E value) {throw Exception("AsyncList is readonly");}

  Future get ready => _ready;

  Future _init() async {
    await loadFromDb();
    return Future.value(null);
  }

  @protected Future loadFromDb();
}