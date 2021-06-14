import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/models/money_operation.dart';
import 'package:my_securities/models/operation.dart';
import 'package:my_securities/pages/money_operation_edit_dialog.dart';
import 'package:my_securities/pages/operation_edit_dialog.dart';
import 'package:my_securities/widgets/portfolio_monies_list_view.dart';
import 'package:provider/provider.dart';
import 'package:my_securities/widgets/appbar.dart';
import 'package:my_securities/widgets/portfolio_instrument_list_view.dart';
import 'package:my_securities/models/portfolio.dart';

class PortfolioInstrumentsPage extends StatelessWidget {
  final Portfolio _portfolio;

  PortfolioInstrumentsPage(this._portfolio, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    addOperation() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => OperationEditDialog(Operation.empty(portfolio: _portfolio)))
      );
    }

    addMoneyOperation() {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => MoneyOperationEditDialog(MoneyOperation.empty(portfolio: _portfolio)))
      );
    }

    return
      Scaffold(
        appBar: MySecuritiesAppBar(pageName: "${_portfolio.name}"),
        body:
          ChangeNotifierProvider<Portfolio>.value(
            value: _portfolio,
            builder: (context, _) {
              Portfolio portfolio = context.watch<Portfolio>();

              return Column(children: [
                PortfolioInstrumentsListView(portfolio),
                PortfolioMoniesListView(portfolio)
              ]);
            }
          ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          backgroundColor: Colors.blue,
          visible: true,
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              child: Icon(Icons.attach_money),
              backgroundColor: Colors.blue,
              label: S.of(context).portfolioInstrumentPageAddMoneyOperation,
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Colors.blue,
              onTap: () {
                addMoneyOperation();
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.add_chart),
              backgroundColor: Colors.blue,
              label: S.of(context).portfolioInstrumentPageAddOperation,
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Colors.blue,
              onTap: () {
                addOperation();
              },
            ),
          ]
        )
      );
  }
}
