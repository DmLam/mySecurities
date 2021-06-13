import 'package:flutter/material.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/models/instrument.dart';
import 'package:my_securities/models/operation.dart';
import 'package:my_securities/models/portfolio.dart';
import 'package:my_securities/pages/operation_edit_dialog.dart';
import 'package:my_securities/widgets/appbar.dart';
import 'package:my_securities/widgets/operations_list_view.dart';
import 'package:provider/provider.dart';

class PortfolioOperationsPage extends StatelessWidget {
  final Portfolio _portfolio;
  final Instrument _instrument;

  const PortfolioOperationsPage(this._portfolio, {Instrument instrument, Key key}) :
    _instrument = instrument,
    super(key: key);

  @override
  Widget build(BuildContext context) {

    addOperation() async {
      Operation operation = Operation.empty(portfolio: _portfolio, instrument: _instrument);

      await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => OperationEditDialog(operation),
            fullscreenDialog: true
        )
      );
    }

    return
      Scaffold(
        appBar: MySecuritiesAppBar(pageName: S.of(context).portfolioOperations_Title(_portfolio.name)),
        body: ChangeNotifierProvider<Portfolio>.value(
            value: _portfolio,
            child: OperationsListView(instrument: _instrument)),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: addOperation,
        ),
      );
  }
}
