import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_securities/common/utils.dart';
import 'package:my_securities/constants.dart';
import 'package:my_securities/exchange.dart';
import 'package:my_securities/models/money_operation.dart';
import 'package:my_securities/models/portfolio.dart';
import 'package:provider/provider.dart';

class MoneyOperationsListView extends StatelessWidget {
  final Portfolio _portfolio;
  final Currency _currency;

  const MoneyOperationsListView(this._portfolio, {Currency currency, Key key}) :
    _currency = currency,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MoneyOperation> moneyOperations = _portfolio.moneyOperations.byCurrency(_currency);

    return ListView.builder(
      itemCount: moneyOperations.length,
      itemBuilder: (BuildContext context, int index) =>
        ChangeNotifierProvider<MoneyOperation>.value(
          value: moneyOperations[index],
          child: MoneyOperationsListItem(moneyOperations[index]),
        )
    );
  }
}

class MoneyOperationsListItem extends StatelessWidget {
  final MoneyOperation operation;

  const MoneyOperationsListItem(this.operation, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(children: [
        Text('${MONEY_OPERATION_TYPE_NAMES[operation.type.index]} ${operation.currency.sign()}${operation.amount}',
          style: TextStyle(fontSize: 19)
        ),
        Expanded(
          child: Text(DateFormat.yMd(languageCode(context)).format(operation.date),
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
            textAlign: TextAlign.right
          )
        )
      ])
    );
  }
}

