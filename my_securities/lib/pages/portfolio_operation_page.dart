import 'package:flutter/material.dart';
import 'package:my_securities/database.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/models/instrument.dart';
import 'package:my_securities/models/operation.dart';
import 'package:my_securities/models/portfolio.dart';
import 'package:my_securities/pages/operation_edit_dialog.dart';
import 'package:my_securities/widgets/appbar.dart';
import 'package:my_securities/widgets/operations_list_view.dart';

class PortfolioOperationPage extends StatelessWidget {
  final Portfolio _portfolio;
  final Instrument _instrument;

  const PortfolioOperationPage(this._portfolio, {Instrument instrument, Key key}) :
    _instrument = instrument,
    super(key: key);

  @override
  Widget build(BuildContext context) {

    addOperation() async {
      Operation operation = Operation.empty(portfolio: _portfolio, instrument: _instrument);

      bool result = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => OperationEditDialog(operation),
            fullscreenDialog: true
        )
      );

      if (result != null) {
        _portfolio.operations.addOperation(operation, result);
      }
    }

    return
      Scaffold(
        appBar: MySecuritiesAppBar(pageName: S.of(context).portfolioOperations_Title),
        body: OperationsListView(_portfolio),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: addOperation,
        ),
      );
  }
}
