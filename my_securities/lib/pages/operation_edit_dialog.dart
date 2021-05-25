import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_securities/common/dialog_panel.dart';
import 'dart:ui' as ui;
import 'package:my_securities/common/utils.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/models/operation.dart';
import 'package:my_securities/widgets/appbar.dart';

import '../constants.dart';

class OperationEditDialog extends StatelessWidget {
  final Operation _operation;
  final TextEditingController _dateEditController = TextEditingController();
  final TextEditingController _priceEditController = TextEditingController();
  final TextEditingController _quantityEditController = TextEditingController();
  final TextEditingController _commissionEditController = TextEditingController();

  OperationEditDialog(this._operation, {Key key}) : super(key: key) {
    _dateEditController.text = DateFormat.yMd(ui.window.locale.languageCode).format(_operation.date);
    _priceEditController.text = (_operation.price ?? 0) == 0 ? '' : _operation.price.toString();
    _quantityEditController.text = (_operation.quantity ?? 0) == 0 ? '' : _operation.quantity.toString();
    _commissionEditController.text = (_operation.commission ?? 0) == 0 ? '' : _operation.commission.toString();
  }

  @override
  Widget build(BuildContext context) {
    String pageName = _operation.id == null ?
      S.of(context).operationEditDialog_Title_add :
      S.of(context).operationEditDialog_Title_edit;

    bool _fabEnabled() {
      return false;
    }

    onFabPressed() {

    }

    return
      Scaffold(
        appBar: MySecuritiesAppBar(pageName: pageName),
        body: SingleChildScrollView(child:
          Column(children: [
            dialogPanel(children: [
              Expanded(flex: 45,
                child: TextField(textAlign: TextAlign.end,
                  controller: _dateEditController,
                  readOnly: true,
                  decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: S.of(context).operationEditDialog_date,
                      contentPadding: EDIT_UNDERLINE_PADDING
                  ),
                  onTap: () {
                    showDatePicker(
                        context: context,
                        initialDate: _operation.date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now()).then((date) =>
                    {
                      if (date != null)
                        _dateEditController.text = DateFormat.yMd(ui.window.locale.languageCode).format(date)
                    });
                  }
                )
              ),
              Expanded(flex: 10, child: Text('')),
              Expanded(flex: 45,
                  // operation type
                  child: DropdownButtonFormField(
                      value: OPERATION_TYPE_NAMES[_operation.type.index],
                      items: OperationType.values.map((type) => DropdownMenuItem(value: OPERATION_TYPE_NAMES[type.index], child: Text(OPERATION_TYPE_NAMES[type.index]))).toList(),
                      decoration: InputDecoration(
                          icon: Icon(Icons.calculate),
                          labelText: S.of(context).operationEditDialog_operationtype,
                          contentPadding: EdgeInsets.all(3.0)
                      ),
                      isExpanded: true,
                      onChanged: (type) {}
                  )
              )
            ]),
          ])
        ),
        floatingActionButton:       // don't show FAB if keyboard is opened, because the FAB overflows most bottom editor
          Visibility(
            visible: isKeyboardOpen(context), // check keyboard is open
            child: FloatingActionButton(
              child: Icon(Icons.done),
                  // if not all data is entered ok then disable FAB: make it grey and null as 'onPressed'
                onPressed: _fabEnabled() ? onFabPressed : null,
                backgroundColor: _fabEnabled() ? Colors.lightBlueAccent : Colors.grey[100]
            )
          )
        );
  }
}
