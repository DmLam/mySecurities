import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttericon/font_awesome_icons.dart';  // todo: check the library version
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_securities/common/dialog_panel.dart';
import 'package:my_securities/common/utils.dart';
import 'package:my_securities/database.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/models/instrument.dart';
import 'package:my_securities/models/money.dart';
import 'package:my_securities/models/operation.dart';
import 'package:my_securities/widgets/appbar.dart';
import '../constants.dart';
import '../exchange.dart';
import '../stock_exchange_interface.dart';

class OperationEditDialog extends StatefulWidget {
  final Operation _operation;
  final Instrument? _operationInstrument;

  OperationEditDialog(this._operation, {Key? key}) :
    _operationInstrument = _operation.instrument,
    super(key: key);

  @override
  _OperationEditDialogState createState() {
    return _OperationEditDialogState(_operation);
  }
}

class _OperationEditDialogState extends State<OperationEditDialog> {
  Operation _operation;
  late DateTime operationDate;
  final TextEditingController _tickerEditController = TextEditingController();
  final TextEditingController _dateEditController = TextEditingController();
  final TextEditingController _priceEditController = TextEditingController();
  final TextEditingController _quantityEditController = TextEditingController();
  final TextEditingController _commissionEditController = TextEditingController();
  final TextEditingController _instrumentNameEditController = TextEditingController();
  final TextEditingController _commentEditController = TextEditingController();
  bool _createMoneyOperation = true;
  bool _priceEdited = false;
  bool _commissionEdited = false;

  _OperationEditDialogState(this._operation);

  void _init() async {
    operationDate = _operation.date ??
        await DBProvider.db.getMostLastOperationDate() ?? currentDate();

    widget._operation.date = operationDate;

    _tickerEditController.text = _operation.instrument?.ticker ?? "";
    _instrumentNameEditController.text = _operation.instrument?.name ?? "";
    _dateEditController.text = dateString(operationDate);
    _priceEditController.text = _operation.price?.toString() ?? "";
    _quantityEditController.text = _operation.quantity?.toString() ?? "";
    _commissionEditController.text = _operation.commission?.toString() ?? "";
    _commentEditController.text = _operation.comment ?? "";
    receiveInstrumentPrice();
  }

  @override void initState() {
    super.initState();

    _init();
  }

  receiveInstrumentPrice() async {
    if (!_priceEdited && (_tickerEditController.text != "")) {
      double? price = await StockExchangeProvider.stock()
          .getInstrumentPrice(
          _tickerEditController.text, date: _operation.date);
      if (price != null)
        _priceEditController.text = formatCurrency(price);
    }
  }

  @override
  Widget build(BuildContext context) {
    String pageName = _operation.id == null ?
      S.of(context).operationEditDialog_Title_add :
      S.of(context).operationEditDialog_Title_edit;

    addOperation() async {
      if (_createMoneyOperation) {
        Money? money = _operation.portfolio.monies.byCurrency(_operation.instrument?.currency);

        if ((_operation.type == OperationType.buy) &&
            (money == null || money.amount < _operation.value)) {
          Fluttertoast.showToast(msg: S.of(context).operationEditDialog_noenoughmoney);
          return;
        }
      }

      _operation.add(_createMoneyOperation);
    }

    editOperation() async {
      // check for money operation
      _operation.update(_createMoneyOperation);
    }

    bool _fabEnabled() {
      return widget._operationInstrument?.ticker != null &&
        widget._operation.date != null &&
        _operation.type != null &&
        ((int.tryParse(_quantityEditController.text) ?? 0) != 0) &&
        ((double.tryParse(_priceEditController.text) ?? 0) != 0);
    }

    onFabPressed() async {
      if (_operation.instrument == null) {
        String? ticker = widget._operationInstrument?.ticker;
        String? isin = widget._operationInstrument?.isin;
        String? name = widget._operationInstrument?.name;
        String? additional = widget._operationInstrument?.additional;
        Currency? currency = widget._operationInstrument?.currency;
        InstrumentType? type = widget._operationInstrument?.type;
        Exchange? exchange = widget._operationInstrument?.exchange;

        if (ticker != null && isin != null && name != null && currency != null && type != null &&
            exchange != null) {
          _operation.instrument = Instrument(
              portfolio: _operation.portfolio,
              ticker: ticker,
              isin: isin,
              name: name,
              currency: currency,
              type: type,
              exchange: exchange,
              additional: additional);
          await widget._operationInstrument?.add();
        }
      }

      try {
        int? quantity = int.tryParse(_quantityEditController.text);
        double? price = double.tryParse(_priceEditController.text);
        double comission = double.tryParse(_commissionEditController.text) ?? 0;

        if (quantity != null && price != null) {
          _operation.quantity = quantity;
          _operation.price = price;
          _operation.commission = comission;
        }
      }
      catch (e) {
        if (e is NoCurrencyException)
          Fluttertoast.showToast(msg: S.of(context).errorNoCurrency);
        else
        if (e is NotEnoughMoneyException)
          Fluttertoast.showToast(msg: S.of(context).errorNotEnoughMoney);
        else
          throw(e);

        return;
      }

      if (_operation.id == null)
        await addOperation();
      else
        await editOperation();

      Navigator.of(context).pop(true);
    }

    void focusChange(TextEditingController controller, bool focused) {
      if (focused)
        controller.selection =
            TextSelection(
                baseOffset: 0,
                extentOffset: controller.value.text.length
            );
    }

    void recalcCommission() async {
      if (!_commissionEdited) {
        int quantity = int.tryParse(_quantityEditController.text) ?? 0;
        double price = double.tryParse(_priceEditController.text) ?? 0;

        if (quantity != 0 && price != 0) {
          double? commission = _operation.portfolio.commission;
          String ticker = _tickerEditController.text;
          if (ticker != '') {
            Instrument? instrument = _operation.portfolio.instruments.byTicker(ticker);
            if (instrument != null && (instrument.commission  != null))
              commission = instrument.commission;
          }

          if (commission != null)
            _commissionEditController.text = formatCurrency((quantity * price * commission).ceilToDouble() / 100, digits: 2);
        }
      }
    }

    Future<List<SearchItem>> tickerSuggestions(String pattern) async {
      return StockExchangeProvider.stock().search(ticker: _tickerEditController.text);
    }

    suggestionSelected(SearchItem suggestion) {
      if (widget._operationInstrument?.ticker != suggestion.ticker) {
        _tickerEditController.text = suggestion.ticker;
        _instrumentNameEditController.text = suggestion.name;
        widget._operationInstrument?.ticker = suggestion.ticker;
        widget._operationInstrument?.name = suggestion.name;
        widget._operationInstrument?.isin = suggestion.isin;
        widget._operationInstrument?.type = suggestion.type;
        widget._operationInstrument?.exchange = suggestion.exchange;
        widget._operationInstrument?.currency = suggestion.currency;
        widget._operationInstrument?.additional = suggestion.additional;
        _operation.instrument = null;
        receiveInstrumentPrice();
      }
    }

    // build code starts here
    return
      Scaffold(
        appBar: MySecuritiesAppBar(pageName: pageName),
        body: SingleChildScrollView(child:
          Column(children: [
            // instrument
            dialogPanel(children: [
              Expanded(flex: 30,
                child: TypeAheadFormField( // ticker
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: _tickerEditController,
                      // let the user to select instrument only when the operation had been added not
                      // from the list of operations of an instrument
                      enabled: _operation.instrument == null,
                      decoration: InputDecoration(
                        icon: Icon(FontAwesome.tag),
                        labelText: S.of(context).operationEditDialog_instrumentticker,
                        contentPadding: EDIT_UNDERLINE_PADDING
                      ),
                      inputFormatters: [UpperCaseTextFormatter()],
                  ),
                  itemBuilder: (BuildContext context, SearchItem suggestion) {
                    return ListTile(
                      title: Text(suggestion.ticker),
                      subtitle: Text(suggestion.name),
                    );
                  },
                  debounceDuration: const Duration(milliseconds: 700),
                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width / 4 * 3,
                      )
                  ),
                  suggestionsCallback: tickerSuggestions,
                  onSuggestionSelected: suggestionSelected,
                  noItemsFoundBuilder: (context) {
                    return Container(
                        padding: EdgeInsets.all(5.0),
                        child: Text(S.of(context).operationEditDialog_notickersuggestion)
                    );
                  },
                ),
              ), // TypeAheadFormField
              Expanded(flex: 10, child: Text('')),
              Expanded(flex: 60,
                child: TextField( // instrument name
                  controller: _instrumentNameEditController,
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
                        initialDate: _operation.date ?? currentDate(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now()).then((value)
                        {
                          if (value != null) {
                            if (_operation.date != value) {
                              _operation.date = value;
                              _dateEditController.text = dateString(value);
                              receiveInstrumentPrice();
                            }
                          }
                        });
                  }
                )
              ),
              Expanded(flex: 10, child: Text('')),
              Expanded(flex: 45,
                   // operation type
                  child: DropdownButtonFormField(
                      value: _operation.type?.name,
                      items: OperationType.values.map((type) => DropdownMenuItem(value: OPERATION_TYPE_NAMES[type.index], child: Text(OPERATION_TYPE_NAMES[type.index]))).toList(),
                      decoration: InputDecoration(
                          icon: Icon(Icons.calculate),
                          labelText: S.of(context).operationEditDialog_operationtype,
                          contentPadding: EdgeInsets.all(3.0)
                      ),
                      isExpanded: true,
                      onChanged: (String? type) {
                        if (type != null)
                          _operation.type = OperationType.values[OPERATION_TYPE_NAMES.indexOf(type)];
                      }
                  )
              )
            ]),
            // quantity, price
            dialogPanel(children: [
              Expanded(flex: 45,
                  child: FocusScope(
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
                        String? result;
                        if (value != null && value != '') {
                          if (_operation.quantity == null) {
                            result = S.of(context).errorInvalidValue;
                          }
                        }
                        return result;
                      },
                      onChanged: (text) {
                        recalcCommission();
                      },
                    ),
                    onFocusChange: (focused) {
                      focusChange(_quantityEditController, focused);
                    },
                  ),
              ),
              Expanded(flex: 10, child: Text('')),
              Expanded(flex: 45,
                  child: FocusScope(
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
                        String? result;
                        if (value != null && value != '') {
                          if (_operation.price == null) {
                            result = S.of(context).errorInvalidValue;
                          }
                        }
                        return result;
                      },
                      onChanged: (text) {
                        _priceEdited = text != null && text != '';
                        recalcCommission();
                      }
                    ),
                    onFocusChange: (focused) {
                      focusChange(_priceEditController, focused);
                    },
                  )
              ),
            ]),
            // commission
            dialogPanel(children: [
              Expanded(flex: 50,
                  child: FocusScope(
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      controller:  _commissionEditController,
                      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))
                      ],
                      style: TextStyle(fontSize: 18,
//                          color: _commissionEdited ? Theme.of(context).textTheme.bodyText2.color :
//                            Theme.of(context).primaryColor
                      ),
                      decoration: InputDecoration(
                          icon: Icon(Icons.monetization_on),
                          labelText: S.of(context).operationEditDialog_commission,
                          contentPadding: EDIT_UNDERLINE_PADDING
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        String? result;
                        if (value != null && value != '') {
                          if (_operation.commission == null) {
                            result = S.of(context).errorInvalidValue;
                          }
                        }
                        return result;
                      },
                      onChanged: (text) {
                        _commissionEdited = text != null && text != '';
                      },
                    ),
                    onFocusChange: (focused) {
                      focusChange(_commissionEditController, focused);
                    },
                  )
              ),
              Expanded(flex: 50,
                  child: CheckboxListTile(
                      title: Text(S.of(context).operationEditDialog_withdrawmoney),
                      value: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) => {_createMoneyOperation = (value ?? false)}
                  )
              )
            ]),
            dialogPanel(children: [
              Expanded(
                child: TextField(
                  controller: _commentEditController,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      icon: Icon(Icons.comment),
                      labelText: S.of(context).operationEditDialog_comment,
                      contentPadding: EDIT_UNDERLINE_PADDING
                  ),
                  onChanged: (String value) {_operation.comment = value;},
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
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

