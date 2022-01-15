import 'package:flutter/material.dart';
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
  final Currency? _currency;

  const MoneyOperationsListView(this._portfolio, {Currency? currency, Key? key}) :
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
        ),
      shrinkWrap: true,
    );
  }
}

class MoneyOperationsListItem extends StatelessWidget {
  final MoneyOperation _operation;

  const MoneyOperationsListItem(this._operation, {Key? key}) : super(key: key);

  _editMoneyOperation(BuildContext context) async {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => MoneyOperationEditDialog(_operation)
        )
    );
  }

  _deleteMoneyOperation(BuildContext context) async {
    assert(_operation.date != null, "Operation date is null somehow");

    String operationDate = dateString(_operation.date!);
    String operationDescription = '"${_operation.type?.name} ${_operation.currency?.sign}${_operation.amount} from $operationDate"';
    String confirmation = await messageDialog(context,
        title: S.of(context).moneyOperationsListView_confirmDeleteDialogTitle,
        content: S.of(context).moneyOperationsListView_confirmDeleteDialogContent(operationDescription),
        actions: [S.of(context).dialogAction_Continue, S.of(context).dialogAction_Cancel],
        defaultResult: S.of(context).dialogAction_Cancel);

    if (confirmation == S.of(context).dialogAction_Continue) {
      _operation.delete();
      if (_operation.portfolio.moneyOperations.byCurrency(_operation.currency).length == 1)
        // if the operation was the last one on this currency - close the page
        Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = DefaultTextStyle.of(context).style;
    TextStyle largeStyle = const TextStyle(fontSize: 18),
        middleStyle = const TextStyle(fontSize: 16),
        greenStyle = const TextStyle(color: Colors.green);

    assert(_operation.type != null, "Operation type is null somehow");
    assert(_operation.date != null, "Operation date is null somehow");

    return ListTile(
      leading: Icon(_operation.type!.income ? Icons.add_circle_outline : Icons.remove_circle_outline),
      minLeadingWidth: 10,
      title: Container(
        child: Column(
          children: [
            Row(children: [
              RichText(text: TextSpan(
                  text: '${_operation.type!.name}  ',
                  style: defaultStyle.merge(middleStyle),
                  children: [
                    TextSpan(text: "${_operation.currency?.sign}", style: defaultStyle.merge(_operation.type!.income ? greenStyle : null)),
                    TextSpan(text: "${formatCurrency(_operation.amount.abs())}",
                        style: defaultStyle.merge(largeStyle).merge(_operation.type!.income ? greenStyle : null))
                  ]
                )
              ),
              Expanded(
                child: Text(dateString(_operation.date!),
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                  textAlign: TextAlign.right
                )
              )
            ]),
          ]
        ),
      ),
      subtitle: Text(_operation.comment ?? "",
          style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500, color: Colors.blueGrey),
          maxLines: 1
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      dense: true,
      visualDensity: VisualDensity(horizontal: 0, vertical: -2),
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
      // we can edit only operations not created as concomitant to an operation with securities
      onTap: _operation.operation != null ?
          null :
          () {_editMoneyOperation(context);},
    );
  }
}

