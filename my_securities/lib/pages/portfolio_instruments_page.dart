import 'package:flutter/material.dart';
import 'package:my_securities/models/instrument.dart';
import 'package:provider/provider.dart';
import 'package:my_securities/widgets/appbar.dart';
import 'package:my_securities/widgets/portfolio_instrument_list_view.dart';
import 'package:my_securities/models/portfolio.dart';

class PortfolioInstrumentsPage extends StatelessWidget {
  final Portfolio _portfolio;

  PortfolioInstrumentsPage(this._portfolio, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return
      ChangeNotifierProvider<InstrumentList>.value(
        value: _portfolio.instruments,
        builder: (context, widget ) {
          return Scaffold(
            appBar: MySecuritiesAppBar(pageName: "${_portfolio.name}"),
            body: PortfolioInstrumentsListView(context.read<InstrumentList>()),
          );
        }
    );
  }
}
