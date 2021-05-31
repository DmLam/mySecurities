import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:intl/intl.dart';
import 'package:my_securities/common/dialog_panel.dart';
import 'dart:ui' as ui;
import 'package:my_securities/common/utils.dart';
import 'package:my_securities/database.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/models/instrument.dart';
import 'package:my_securities/models/operation.dart';
import 'package:my_securities/widgets/appbar.dart';
import '../constants.dart';
import '../exchange.dart';
import '../stock_exchange_interface.dart';

class OperationEditDialog extends StatelessWidget {
  final Operation _operation;
  final TextEditingController _tickerEditController = TextEditingController();
  final TextEditingController _dateEditController = TextEditingController();
  final TextEditingController _priceEditController = TextEditingController();
  final TextEditingController _quantityEditController = TextEditingController();
  final TextEditingController _commissionEditController = TextEditingController();

  final TextEditingController _instrumentNameEditController = TextEditingController();

  OperationEditDialog(this._operation, {String instrumentTicker, Key key}) : super(key: key) {
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
    String instrumentTicker;
    DateTime date;
    OperationType type;
    int quantity;
    double price;
    double commission;
    bool _createMoneyOperation = true;

    String instrumentName;
    String instrumentIsin;
    InstrumentType instrumentType;
    Exchange instrumentExchange;
    Currency instrumentCurrency;
    String instrumentAdditional;

    addOperation() async {
      if (_operation.instrument == null) {
        Instrument instrument = await _operation.portfolio.instruments.add(
            instrumentTicker,
            instrumentIsin,
            instrumentName,
            instrumentCurrency,
            instrumentType,
            instrumentExchange,
            instrumentAdditional);
        _operation.update(instrument: instrument);
      }

      if (_operation.id == null)
        _operation.portfolio.operations.addOperation(_operation, _createMoneyOperation);
      else
        _operation.update(date: date, type: type, quantity: quantity, price: price, commission: commission);
    }
    
    bool _fabEnabled() {
      return instrumentTicker != null &&
        date != null &&
        type != null &&
        quantity != null &&
        price != null;
    }

    onFabPressed() async  {
      Navigator.of(context).pop(true);
      addOperation();
    }

    Future<List> tickerSuggestions(String pattern) async {
      return StockExchangeProvider.stock().search(ticker: _tickerEditController.text);
    }

    return
      Scaffold(
        appBar: MySecuritiesAppBar(pageName: pageName),
        body: SingleChildScrollView(child:
          Column(children: [
            // instrument
            dialogPanel(children: [
              Expanded(flex: 30,
                child: TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: _tickerEditController,
                      decoration: InputDecoration(
                          icon: Icon(FontAwesome.tag),
                          labelText: S.of(context).operationEditDialog_instrumentticker,
                          contentPadding: EDIT_UNDERLINE_PADDING
                      ),
                      inputFormatters: [UpperCaseTextFormatter()],
                      onChanged: (value) {
                        instrumentTicker = value;
                      }
                  ),
                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width / 4 * 3,
                      )
                  ),
                  suggestionsCallback: tickerSuggestions,
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion.ticker),
                      subtitle: Text(suggestion.name),
                    );
                  },
                  noItemsFoundBuilder: (context) {
                    return Container(
                        padding: EdgeInsets.all(5.0),
                        child: Text(S.of(context).operationEditDialog_notickersuggestion)
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    _tickerEditController.text = suggestion.ticker ;
                    _instrumentNameEditController.text = suggestion.name;
                    instrumentTicker = suggestion.ticker;
                    instrumentName = suggestion.name;
                    instrumentIsin = suggestion.isin;
                    instrumentType = suggestion.type;
                    instrumentExchange = suggestion.exchange;
                    instrumentCurrency = suggestion.currency;
                    instrumentAdditional = suggestion.additional;
                  }
                ),
              ), // TypeAheadFormField
              Expanded(flex: 10, child: Text('')),
              Expanded(flex: 60,
                child: TextField(controller: _instrumentNameEditController,
                  readOnly: true,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, -5)
                  )
                )
              )
            ]),
            // date, Operation type
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
                        lastDate: DateTime.now()).then((value)
                        {
                          if (value != null) {
                            date = value;
                            _dateEditController.text =
                                DateFormat.yMd(ui.window.locale.languageCode).format(value);
                          }
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
                      onChanged: (type) {type = OperationType.values[OPERATION_TYPE_NAMES.indexOf(type)];}
                  )
              )
            ]),
            // quantity, price
            dialogPanel(children: [
              Expanded(flex: 45,
                  child: TextFormField(
                    textAlign: TextAlign.end,
                    controller:  _quantityEditController,
                    keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        icon: Icon(Icons.filter_1),
                        labelText: S.of(context).operationEditDialog_quantity,
                        contentPadding: EDIT_UNDERLINE_PADDING
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      String result;
                      if (value != null && value != '') {
                        if (_operation.quantity == null) {
                          result = S.of(context).errorInvalidValue;
                        }
                      }
                      return result;
                    },
                    onChanged: (value) {
                      quantity = int.tryParse(value);
                    },
                  )
              ),
              Expanded(flex: 10, child: Text('')),
              Expanded(flex: 45,
                  child: TextFormField(
                    textAlign: TextAlign.end,
                    controller:  _priceEditController,
                    keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        icon: Icon(Icons.attach_money),
                        labelText: S.of(context).operationEditDialog_price,
                        contentPadding: EDIT_UNDERLINE_PADDING
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      String result;
                      if (value != null && value != '') {
                        if (_operation.price == null) {
                          result = S.of(context).errorInvalidValue;
                        }
                      }
                      return result;
                    },
                    onChanged: (value) {
                      price = double.tryParse(value);
                    },
                  )
              ),
            ]),
            // commission
            dialogPanel(children: [
              Expanded(flex: 50,
                  child: TextFormField(
                    textAlign: TextAlign.end,
                    controller:  _commissionEditController,
                    keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))
                    ],
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        icon: Icon(Icons.monetization_on),
                        labelText: S.of(context).operationEditDialog_commission,
                        contentPadding: EDIT_UNDERLINE_PADDING
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      String result;
                      if (value != null && value != '') {
                        if (_operation.commission == null) {
                          result = S.of(context).errorInvalidValue;
                        }
                      }
                      return result;
                    },
                    onChanged: (value) {
                      commission = double.tryParse(value) ?? 0;
                    },
                  )
              ),
              Expanded(flex: 50,
                  child: CheckboxListTile(
                      title: Text(S.of(context).operationEditDialog_withdrawmoney),
                      value: _createMoneyOperation,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value) => {_createMoneyOperation = value}
                  )
              )
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

