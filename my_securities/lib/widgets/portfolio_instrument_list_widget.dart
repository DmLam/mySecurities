import 'package:flutter/material.dart';
import 'package:my_securities/models/instrument.dart';
import 'package:provider/provider.dart';
import 'package:my_securities/models/portfolio.dart';

class PortfolioInstrumentList extends StatelessWidget {
  final Portfolio _portfolio;

  PortfolioInstrumentList(this._portfolio);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _portfolio,
        child: ListView.builder(
          itemCount: _portfolio.operationCount,
          itemBuilder: (BuildContext context, int index) => PortfolioInstrumentListItem(_portfolio.instrument(index))
        )
    );
  }
}

class PortfolioInstrumentListItem extends StatelessWidget {
  final Instrument _instrument;

  PortfolioInstrumentListItem(this._instrument);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_instrument.ticker + _instrument.name == null ? "" : "($_instrument.name)"),
    );
  }
}

