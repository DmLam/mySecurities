import 'package:flutter/material.dart';
import 'package:my_securities/models/instrument.dart';
import 'package:provider/provider.dart';
import 'package:my_securities/widgets/appbar_widget.dart';
import 'package:my_securities/widgets/portfolio_instrument_list_widget.dart';
import 'package:my_securities/models/portfolio.dart';

class PortfolioInstrumentsPage extends StatelessWidget {
  final Portfolio _portfolio;

  PortfolioInstrumentsPage(this._portfolio);

  @override
  Widget build(BuildContext context) {
    return
      ChangeNotifierProvider<InstrumentList>.value(
        value: _portfolio.instruments,
        child: Scaffold(
          appBar: MySecuritiesAppBar(),
          body: PortfolioInstrumentList(context.read<InstrumentList>()),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add)
          ),
      ),
    );
  }
}
