import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_securities/models/portfolio.dart';

class PortfolioList extends ListView {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Portfolios>(
      create: (_) => Portfolios(),
      builder: (context, widget) {return ListView.builder(
        itemCount: context.watch<Portfolios>().length,
        itemBuilder: (context, index) =>
          ListTile(
            title: Text(context.read<Portfolios>()[index].name),
          )
      );}
    );
  }
}
