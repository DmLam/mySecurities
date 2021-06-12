import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_securities/common/message_dialog.dart';
import 'package:provider/provider.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/exchange.dart';
import 'package:my_securities/models/instrument.dart';
import 'package:my_securities/models/operation.dart';
import 'package:my_securities/models/portfolio.dart';
import '../constants.dart';

class OperationsListView extends StatelessWidget {
  final Instrument instrument;

  const OperationsListView({this.instrument, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Portfolio portfolio = context.watch<Portfolio>();

    return ListView.builder(
      itemCount: portfolio.operations.operations.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider<Instrument>.value(
          value: portfolio.operations.operations[index].instrument,
          builder: (context, widget) {
            return operationsListItem(context, portfolio.operations.operations[index]);
          }
        );
      });
  }
}

Widget operationsListItem(BuildContext context, Operation operation) {
  final String languageCode = Localizations.localeOf(context).languageCode;
  Instrument instrument = context.watch<Instrument>();

  editOperation() {

  }

  deleteOperation() async {
    String date = DateFormat.yMd(Intl.getCurrentLocale()).format(operation.date);
    String description =  "${operation.instrument.ticker} * ${operation.quantity} (${date})";
    String confirmation = await messageDialog(context,
        S.of(context).operationsListView_confirmDeleteDialogTitle,
        S.of(context).operationsListView_confirmDeleteDialogContent(description),
        [S.of(context).dialogAction_Continue, S.of(context).dialogAction_Cancel]);

    if (confirmation == S.of(context).dialogAction_Continue)
      operation.delete();
  }

  return ListTile(
      leading: instrument.image == null ? Icon(Icons.attach_money) : Image.memory(instrument.image),
      title: Text("${OPERATION_TYPE_NAMES[operation.type.index]} ${operation.quantity} ${S.of(context).pcs} * ${operation.price} ${instrument.currency.sign()}"),
      subtitle: Row(mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(flex: 70, child: Text("${operation.value.toString()} ${operation.instrument.currency.sign()}")),
            Expanded(flex: 30, child: Text(DateFormat.yMd(languageCode).format(operation.date), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 11), textAlign: TextAlign.right, ))
          ]),
      trailing: PopupMenuButton(
          itemBuilder: (_) => <PopupMenuItem<String>>[
            PopupMenuItem<String>(
              value: "edit",
              child: Text(S.of(context).operationsListViewItem_menuEdit),
            ),

            PopupMenuItem<String>(
              value: "delete",
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
      onLongPress: editOperation
  );

}