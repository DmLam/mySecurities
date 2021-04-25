import 'package:flutter/material.dart';
import 'package:my_securities/widgets/appbar_widget.dart';
import 'package:my_securities/widgets/portfolio_list_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MySecuritiesAppBar(),
      body: PortfolioList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add)
      ),
    );
  }
}
