import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/pages/portfolio_instruments_page.dart';
import 'package:provider/provider.dart';
import 'package:my_securities/models/portfolio.dart';

class PortfolioList extends ListView {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Portfolios>(
      create: (_) => Portfolios(),
      builder: (context, widget) {return ListView.builder(
        itemCount: context.watch<Portfolios>().length,
        itemBuilder: (context, index) => PortfolioListItem(context.read<Portfolios>()[index])
      );}
    );
  }
}

class PortfolioListItem extends StatelessWidget {
  final Portfolio _portfolio;

  PortfolioListItem(this._portfolio);

  @override
  Widget build(BuildContext context) {
    String created;

    showPortfolioInstuments() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PortfolioInstrumentsPage(_portfolio)
        )
      );
    }

    if (_portfolio.startDate != null)
      created = S.of(context).portfolioCreated + ":"+ DateFormat("dd.MM.yyyy").format(_portfolio.startDate);

    return
      GestureDetector(
        child: ListTile(
          title: Text(_portfolio.name,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(created),
        ),
        onTap: showPortfolioInstuments(),
      )
    ;
  }
}
