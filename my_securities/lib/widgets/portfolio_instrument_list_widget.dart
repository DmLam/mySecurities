import 'package:flutter/material.dart';
import 'package:my_securities/models/instrument.dart';
import 'package:provider/provider.dart';

class PortfolioInstrumentList extends StatelessWidget {
  final InstrumentList _instruments;

  PortfolioInstrumentList(this._instruments);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _instruments.length,
      itemBuilder: (BuildContext context, int index) => PortfolioInstrumentListItem(_instruments[index])
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

