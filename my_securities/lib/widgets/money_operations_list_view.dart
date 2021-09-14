import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_securities/common/message_dialog.dart';
import 'package:my_securities/common/utils.dart';
import 'package:my_securities/exchange.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/models/money_operation.dart';
import 'package:my_securities/models/portfolio.dart';
import 'package:my_securities/pages/money_operation_edit_dialog.dart';
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
  final MoneyOperation _operation;

  const MoneyOperationsListItem(this._operation, {Key key}) : super(key: key);

  _editMoneyOperation(BuildContext context) async {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => MoneyOperationEditDialog(_operation)
        )
    );
  }

  _deleteMoneyOperation(BuildContext context) async {
    String operationDate = dateString(_operation.date);
    String operationDescription = '"${_operation.type.name} ${_operation.currency.sign}${_operation.amount} from $operationDate"';
    String confirmation = await messageDialog(context,
        S.of(context).moneyOperationsListView_confirmDeleteDialogTitle,
        S.of(context).moneyOperationsListView_confirmDeleteDialogContent(operationDescription),
        [S.of(context).dialogAction_Continue, S.of(context).dialogAction_Cancel]);

    if (confirmation == S.of(context).dialogAction_Continue) {
      _operation.delete();
      if (_operation.portfolio.moneyOperations.byCurrency(_operation.currency).length == 1)
        // if the operation was the last one on this currency - close the page
        Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(children: [
        Text('${_operation.type.name} ${_operation.currency.sign}${_operation.amount}',
          style: TextStyle(fontSize: 19)
        ),
        Expanded(
          child: Text(dateString(_operation.date),
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
            textAlign: TextAlign.right
          )
        )
      ]),
      trailing: PopupMenuButton(
        itemBuilder: (_) => <PopupMenuItem<String>>[
          PopupMenuItem<String>(
            value: 'edit',
            child: Text(S.of(context).moneyOperationsListView_menuEdit),
          ),
          PopupMenuItem<String>(
            value: 'delete',
            child: Text(S.of(context).moneyOperationsListView_menuDelete),
          ),
        ],
        onSelected: (value) {
          switch (value) {
            case 'edit':
              _editMoneyOperation(context);
              break;
            case 'delete':
              _deleteMoneyOperation(context);
              break;
            default:
              throw Exception("Unknown instrument menu item");
          }
        }
      ),
    );
  }
}

