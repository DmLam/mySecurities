import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_securities/common/message_dialog.dart';
import 'package:my_securities/common/utils.dart';
import 'package:my_securities/pages/operation_edit_dialog.dart';
import 'package:provider/provider.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/exchange.dart';
import 'package:my_securities/models/instrument.dart';
import 'package:my_securities/models/operation.dart';
import 'package:my_securities/models/portfolio.dart';
import '../constants.dart';

class OperationsListView extends StatelessWidget {
  final String _ticker;

  const OperationsListView({String ticker, Key key}) :
        _ticker = ticker,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Portfolio portfolio = context.watch<Portfolio>();
    List<Operation> operations = portfolio.operations.byInstrument(portfolio.instruments.byTicker(_ticker));

    return ListView.builder(
      itemCount: operations.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider<Operation>.value(
          value: operations[index],
          builder: (context, widget) {
            return operationsListItem(context, operations[index]);
          }
        );
      });
  }
}

Widget operationsListItem(BuildContext context, Operation operation) {

  editOperation() async {
   await Navigator.of(context).push(
     MaterialPageRoute(
       builder: (_) => OperationEditDialog(operation),
       fullscreenDialog: true
     ),
   );
  }

  deleteOperation() async {
    String date = dateString(operation.date);
    String description =  "${operation.instrument.ticker} * ${operation.quantity} (${date})";
    String confirmation = await messageDialog(context,
        title: S.of(context).operationsListView_confirmDeleteDialogTitle,
        content: S.of(context).operationsListView_confirmDeleteDialogContent(description),
        actions: [S.of(context).dialogAction_Continue, S.of(context).dialogAction_Cancel],
        defaultResult: S.of(context).dialogAction_Cancel);

    if (confirmation == S.of(context).dialogAction_Continue) {
      await operation.delete();
      // if the operation was the last one on this instrument - close the page
      if (operation.instrument != null && operation.portfolio.operations.byInstrument(operation.instrument).length == 1)
        Navigator.pop(context);
    }
  }

  return GestureDetector(
    child: ListTile(
      leading: operation.instrument.image == null ? Icon(Icons.attach_money) :
        Image.memory(operation.instrument.image),
      title: Text('${operation.type.name} ${operation.quantity} ${S.of(context).pcs} * ${operation.price} ${operation.instrument.currency.sign}'),
      subtitle: Row(mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(flex: 70,
              child: Text('${operation.value.toString()} ${operation.instrument.currency.sign}')),
            Expanded(flex: 30,
              child: Text(dateString(operation.date),
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 11),
                textAlign: TextAlign.right)
            )
          ]),
      trailing: PopupMenuButton(
          itemBuilder: (_) => <PopupMenuItem<String>>[
            PopupMenuItem<String>(
              value: 'edit',
              child: Text(S.of(context).operationsListViewItem_menuEdit),
            ),

            PopupMenuItem<String>(
              value: 'delete',
              child: Text(S.of(context).operationsListViewItem_menuDelete),
            )
          ],
          onSelected: (value) {
            switch(value) {
              case 'edit':
                editOperation();
                break;
              case 'delete':
                deleteOperation();
                break;
              default:
                throw Exception("Unknown instrument menu item");
            }
          }
      ),
    ),
    onTap: editOperation
  );

}