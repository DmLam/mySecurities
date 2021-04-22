import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_securities/models/portfolio.dart';

class PortfolioListItem extends StatelessWidget {
  Portfolio _portfolio;

  PortfolioListItem(this._portfolio);

  @override
  Widget build(BuildContext context) {
    return
      ListTile(
      title: Text(_portfolio.name,
        style: TextStyle(fontSize: 20),
      ),
    )
    ;
  }
}


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
