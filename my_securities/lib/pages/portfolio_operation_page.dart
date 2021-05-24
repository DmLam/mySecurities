import 'package:flutter/material.dart';
import 'package:my_securities/models/instrument.dart';
import 'package:my_securities/models/portfolio.dart';
import 'package:my_securities/widgets/appbar.dart';
import 'package:my_securities/widgets/operation_list_view.dart';

class PortfolioOperationPage extends StatelessWidget {
  final Portfolio _portfolio;
  final Instrument instrument;

  const PortfolioOperationPage(this._portfolio, {this.instrument, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: MySecuritiesAppBar(),
        body: OperationListView(_portfolio));
  }
}
