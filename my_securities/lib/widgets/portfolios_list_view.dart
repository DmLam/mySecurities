import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_securities/common/future_builder.dart';
import 'package:my_securities/common/message_dialog.dart';
import 'package:my_securities/common/types.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/pages/portfolio_edit_dialog.dart';
import 'package:my_securities/pages/portfolio_instruments_page.dart';
import 'package:provider/provider.dart';
import 'package:my_securities/models/portfolio.dart';

import '../preferences.dart';

// https://stackoverflow.com/questions/64936531/provider-integration-with-sqflite-in-flutter-app
class PortfoliosListView extends ListView {
  final Preferences _preferences;

  PortfoliosListView(this._preferences);

  @override
  Widget build(BuildContext context) {
    bool showHiddenPortfolios = _preferences.showHiddenPortfolios;

    return futureBuilder(
        future: context.watch<PortfolioList>().ready,
        resultWidget: (_) {
          PortfolioList list = context.read<PortfolioList>();

          return ListView.builder(
              itemCount: showHiddenPortfolios ? list.portfolios.length : list.visiblePortfolios.length,
              itemBuilder: (context, index) =>
                  PortfolioListViewItem(showHiddenPortfolios ? list.portfolios[index] : list.visiblePortfolios[index])

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
    await Navigator.of(context).push(
        MaterialPageRoute(
          builder:(_) => PortfolioEditDialog(_portfolio),
          fullscreenDialog: true
        )
    );
  }

  _deletePortfolio(BuildContext context) async {
    String portfolioName = context.read<Portfolio>().name;
    String confirmation = await messageDialog(context,
        title: S.of(context).portfoliosListView_confirmDeleteDialogTitle,
        content: S.of(context).portfoliosListView_confirmDeleteDialogContent(portfolioName),
        actions: [S.of(context).dialogAction_Continue, S.of(context).dialogAction_Cancel],
        defaultResult: S.of(context).dialogAction_Cancel
    );

    if (confirmation == S.of(context).dialogAction_Continue)
      _portfolio.delete();
  }

  @override
  Widget build(BuildContext context) {
    String started = S.of(context).portfoliosListView_portfolioStarted + ': '+
        DateFormat('dd.MM.yyyy').format(_portfolio.startDate);

    return
      ChangeNotifierProvider<Portfolio>.value(
        value: _portfolio,
        builder: (context, _) {
          return GestureDetector(
            child: ListTile(
              title: Text(context.watch<Portfolio>().name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _portfolio.visible ? Theme.of(context).textTheme.subtitle1!.color : Theme.of(context).disabledColor
                ),
              ),
              subtitle: Text(started),
              trailing: PopupMenuButton(
                  itemBuilder: (_) =>
                    <PopupMenuItem<String>>[
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Text(S.of(context).portfoliosListView_menuEdit),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Text(S.of(context).portfoliosListView_menuDelete),
                      ),
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
                        InternalException("Unknown instrument menu item");
                    }
                  }
              ),
            ),
            onTap: () {_showPortfolioInstruments(context);},
          );
        }
      );
  }
}
