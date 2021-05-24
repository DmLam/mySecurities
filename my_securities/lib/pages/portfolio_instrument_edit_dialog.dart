import 'package:flutter/material.dart';
import 'package:my_securities/models/instrument.dart';
import 'package:my_securities/widgets/appbar.dart';
import 'package:provider/provider.dart';

class PortfolioInstrumentEditDialog extends StatelessWidget {
  final Instrument _instrument;

  const PortfolioInstrumentEditDialog(this._instrument, {Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MySecuritiesAppBar(),
      body: ChangeNotifierProvider<Instrument>.value(
        value: _instrument,
        child: Container(),
      )
    );
  }
}
