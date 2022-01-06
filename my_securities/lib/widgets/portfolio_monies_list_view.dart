import 'package:flutter/material.dart';
import 'package:my_securities/exchange.dart';
import 'package:my_securities/models/money.dart';
import 'package:my_securities/models/portfolio.dart';
import 'package:my_securities/pages/portfolio_money_operation_page.dart';
import 'package:provider/provider.dart';

class PortfolioMoniesListView extends StatelessWidget {
  final Portfolio _portfolio;

  const PortfolioMoniesListView(this._portfolio, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _portfolio.monies.length,
        itemBuilder: (BuildContext context, int index) =>
          ChangeNotifierProvider<Money>.value(
            value: _portfolio.monies[index],
            child: PortfolioMoniesListItem(_portfolio.monies[index])
          )
    );
  }
}

class PortfolioMoniesListItem extends StatelessWidget {
  final Money _money;

  PortfolioMoniesListItem(this._money);

  @override
  Widget build(BuildContext context) {

    showMoneyOperations() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PortfolioMoneyOperationsPage(_money.portfolio, currency: _money.currency))
      );
    }

    return GestureDetector(
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(2.0, 0.0, 8.0, 0.0),
        leading: Container(
            width: 36,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(CurrencySigns[_money.currency.index],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.teal, fontSize: 36),
                  ),
                  Text(_money.currency.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.teal, fontSize: 12),
                  )
                ]
            )
        ),
        title: Text(formatCurrency(_money.amount, digits: 2),
          style: TextStyle(fontSize: 30)
        ),
      ),
      onTap: showMoneyOperations,
    );
  }

}
