import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_securities/common/classes.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/pages/portfolio_instruments_page.dart';
import 'package:provider/provider.dart';
import 'package:my_securities/models/portfolio.dart';

// https://stackoverflow.com/questions/64936531/provider-integration-with-sqflite-in-flutter-app
class PortfolioListView extends ListView {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PortfolioList>(
      create: (_) => PortfolioList(),
      builder: (context, widget) {
        return futureBuilder(
          future: context.watch<PortfolioList>().ready,
          resultWidget: (_) {
            return ListView.builder(
              itemCount: context.read<PortfolioList>().portfolios.length,
              itemBuilder: (context, index) => PortfolioListViewItem(context.read<PortfolioList>().portfolios[index])
            );
          }
        );
      }
    );
  }
}

class PortfolioListViewItem extends StatelessWidget {
  final Portfolio _portfolio;

  PortfolioListViewItem(this._portfolio);

  @override
  Widget build(BuildContext context) {
    String created;

    showPortfolioInstruments() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PortfolioInstrumentsPage(_portfolio)
        )
      );
    }

    if (_portfolio.startDate != null)
      created = S.of(context).portfolioCreated + ": "+ DateFormat("dd.MM.yyyy").format(_portfolio.startDate);

    return
      GestureDetector(
        child: ListTile(
          title: Text(_portfolio.name,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(created),
        ),
        onTap: showPortfolioInstruments,
      )
    ;
  }
}
