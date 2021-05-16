import 'package:flutter/material.dart';
import 'package:my_securities/preferences.dart';
import 'package:provider/provider.dart';
import 'package:my_securities/models/portfolio.dart';
import 'package:my_securities/pages/portfolio_edit_dialog.dart';
import 'package:my_securities/widgets/appbar.dart';
import 'package:my_securities/widgets/portfolio_list_view.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    addPortfolio () {
      PortfolioList owner = context.read<PortfolioList>();

      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PortfolioEditDialog(Portfolio.empty(owner)))
      );
    }

    return Scaffold(
      appBar: MySecuritiesAppBar(),
      body: PortfolioListView(context.read<Preferences>()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addPortfolio,
      ),
    );
  }
}
