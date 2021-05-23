import 'package:flutter/material.dart';
import 'package:my_securities/models/instrument.dart';
import 'package:my_securities/models/portfolio.dart';

class OperationListView extends StatelessWidget {
  final Portfolio _portfolio;
  final Instrument instrument;

  const OperationListView(this._portfolio, {this.instrument, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _portfolio.operations.operations.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_portfolio.operations.operations[index].instrument.ticker)
        );
      });
  }
}
