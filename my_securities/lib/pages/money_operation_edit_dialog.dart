import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:my_securities/common/dialog_panel.dart';
import 'package:my_securities/common/utils.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/models/money_operation.dart';
import 'package:my_securities/widgets/appbar.dart';
import '../constants.dart';
import '../exchange.dart';

class MoneyOperationEditDialog extends StatelessWidget {
  final MoneyOperation _moneyOperation;
  final TextEditingController _dateEditController = TextEditingController();
  final TextEditingController _amountEditController = TextEditingController();

  MoneyOperationEditDialog(this._moneyOperation, {Key key}) : super(key: key) {
    _dateEditController.text = DateFormat.yMd(ui.window.locale.languageCode).format(_moneyOperation.date);
    _amountEditController.text = (_moneyOperation.amount ?? 0) == 0 ? '' : _moneyOperation.amount.toString();
  }

  @override
  Widget build(BuildContext context) {
    String pageName = _moneyOperation.id == null ?
      S.of(context).moneyOperationEditDialog_Title_add :
      S.of(context).moneyOperationEditDialog_Title_edit;

    addMoneyOperation() async {
      _moneyOperation.add();
    }

    bool _fabEnabled() {
      return _moneyOperation.date != null &&
          _moneyOperation.currency != null &&
          _moneyOperation.type != null &&
          _moneyOperation.amount != null;
    }

    onFabPressed() async  {
      Navigator.of(context).pop(true);
      addMoneyOperation();
    }


    return Scaffold(
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
                    labelText: S.of(context).moneyOperationEditDialog_date,
                    contentPadding: EDIT_UNDERLINE_PADDING
                ),
                onTap: () {
                  showDatePicker(
                      context: context,
                      initialDate: _moneyOperation.date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now()).then((value)
                  {
                    if (value != null) {
                      _moneyOperation.date = value;
                      _dateEditController.text =
                          DateFormat.yMd(ui.window.locale.languageCode).format(value);
                    }
                  });
                }
              )
            ),
            Expanded(flex: 10, child: Text('')),
            Expanded(flex: 45,
              child: DropdownButtonFormField (
                value: _moneyOperation.currency,
                decoration: InputDecoration(
                    icon: Icon(Icons.attach_money),
                    labelText: S.of(context).moneyOperationEditDialog_currency,
                    contentPadding: EDIT_UNDERLINE_PADDING
                ),
                items: Currency.values.map((c) =>
                  DropdownMenuItem<Currency>(
                    value: c,
                    child: Text(c.name()),
                  )
                ).toList(),
                onChanged: (value) {_moneyOperation.currency = value;},
              )
            ),
          ]),
          dialogPanel(children: [
            Expanded(flex: 45,
              child: DropdownButtonFormField (
                value: _moneyOperation.type,
                decoration: InputDecoration(
                    icon: Icon(Icons.attach_money),
                    labelText: S.of(context).moneyOperationEditDialog_operationtype,
                    contentPadding: EDIT_UNDERLINE_PADDING
                ),
                items: [
                  DropdownMenuItem(
                    value: MoneyOperationType.deposit,
                    child: Text(MONEY_OPERATION_TYPE_NAMES[MoneyOperationType.deposit.index]),
                  ),
                  DropdownMenuItem(
                    value: MoneyOperationType.withdraw,
                    child: Text(MONEY_OPERATION_TYPE_NAMES[MoneyOperationType.withdraw.index]),
                  )
                ],
                onChanged: (value) {_moneyOperation.type = value;},
              )
            ),
            Expanded(flex: 10, child: Text('')),
            Expanded(flex: 45,
              child: TextFormField(
                textAlign: TextAlign.end,
                controller:  _amountEditController,
                keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                    icon: Icon(Icons.filter_1),
                    labelText: S.of(context).moneyOperationEditDialog_amount,
                    contentPadding: EDIT_UNDERLINE_PADDING
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  String result;
                  if (value != null && value != '') {
                    if (_moneyOperation.amount == null) {
                      result = S.of(context).errorInvalidValue;
                    }
                  }
                  return result;
                },
                onChanged: (value) {
                  _moneyOperation.amount = double.tryParse(value);
                },
              )
            ),
          ])
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
