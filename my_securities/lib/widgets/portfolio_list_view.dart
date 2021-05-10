import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_securities/common/future_builder.dart';
import 'package:my_securities/common/message_dialog.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/pages/portfolio_edit_dialog.dart';
import 'package:my_securities/pages/portfolio_instruments_page.dart';
import 'package:provider/provider.dart';
import 'package:my_securities/models/portfolio.dart';

// https://stackoverflow.com/questions/64936531/provider-integration-with-sqflite-in-flutter-app
class PortfolioListView extends ListView {
  @override
  Widget build(BuildContext context) {

    return futureBuilder(
        future: context.watch<PortfolioList>().ready,
        resultWidget: (_) {
          return ListView.builder(
              itemCount: context
                  .read<PortfolioList>()
                  .portfolios
                  .length,
              itemBuilder: (context, index) =>
                  PortfolioListViewItem(context
                      .read<PortfolioList>()
                      .portfolios[index])
          );
        }
    );
  }
}

class PortfolioListViewItem extends StatelessWidget {
  final Portfolio _portfolio;

  PortfolioListViewItem(this._portfolio);

  _showPortfolioInstruments(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => PortfolioInstrumentsPage(_portfolio)
        )
    );
  }

  _editPortfolio(BuildContext context) async {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder:(_) => PortfolioEditDialog(_portfolio)
        )
    );
  }

  _deletePortfolio(BuildContext context) async {
    String portfolioName = context.read<Portfolio>().name;
    String confirmation = await messageDialog(context,
        S.of(context).portfolioListView_confirmDeleteDialogTitle,
        S.of(context).portfolioListView_confirmDeleteDialogContent(portfolioName),
        [S.of(context).dialogAction_Continue, S.of(context).dialogAction_Cancel]);

    if (confirmation == S.of(context).dialogAction_Continue)
      context.read<PortfolioList>().delete(_portfolio);
  }
  @override
  Widget build(BuildContext context) {
    String started;

    return
      ChangeNotifierProvider<Portfolio>.value(
        value: _portfolio,
        builder: (context, _) {
          if (_portfolio.startDate != null)
            started = S.of(context).portfolioListView_portfolioStarted + ': '+
                DateFormat('dd.MM.yyyy').format(context.read<Portfolio>().startDate);

          return GestureDetector(
            child: ListTile(
              title: Text(context.watch<Portfolio>().name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(started ?? ''),
              trailing: PopupMenuButton(
                  itemBuilder: (_) =>
                  <PopupMenuItem<String>>[
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Text(S.of(context).portfolioListView_menuEdit),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text(S.of(context).portfolioListView_menuDelete),
                    )
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _editPortfolio(context);
                        break;
                      case 'delete':
                        _deletePortfolio(context);
                        break;
                      default:
                        throw Exception("Unknown instrument menu item");
                    }
                  }
              ),
              //          onLongPress: editOperation,
            ),
            onTap: () {_showPortfolioInstruments(context);},
          );
        }
      );
  }
}
