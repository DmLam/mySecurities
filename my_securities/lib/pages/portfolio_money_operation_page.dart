import 'package:flutter/material.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/models/money_operation.dart';
import 'package:my_securities/models/portfolio.dart';
import 'package:my_securities/widgets/appbar.dart';
import 'package:my_securities/widgets/money_operations_list_view.dart';
import 'package:provider/provider.dart';

import '../exchange.dart';
import 'money_operation_edit_dialog.dart';

class PortfolioMoneyOperationsPage extends StatelessWidget {
  final Portfolio _portfolio;
  final Currency _currency;

  const PortfolioMoneyOperationsPage(this._portfolio, {Currency currency, Key key}) :
    _currency = currency,
    super(key: key);

  @override
  Widget build(BuildContext context) {

    addMoneyOperation() {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => MoneyOperationEditDialog(MoneyOperation.empty(portfolio: _portfolio)))
      );
    }

    return Scaffold(
      appBar: MySecuritiesAppBar(pageName: S.of(context).portfolioMoneyOperations_Title(_portfolio.name)),
      body: ChangeNotifierProvider<Portfolio>.value(
        value: _portfolio,
        child: MoneyOperationsListView(_portfolio, currency: _currency),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addMoneyOperation,
      )
    );
  }
}
