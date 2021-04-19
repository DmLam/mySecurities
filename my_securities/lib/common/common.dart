import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import 'exchange.dart';

const CURRENT_PRICE_CACHE_TIME = 60; // seconds

List CurrencyNames = Currency.values.map((currency) => currency.name()).toList(); // ignore: non_constant_identifier_names

List INSTRUMENT_TYPE_NAMES = [S.current.instrumentTypeCurrency, S.current.instrumentTypeShare, S.current.instrumentTypeEtf, S.current.instrumentTypeBond]; // ignore: non_constant_identifier_names

List OPERATION_TYPE_NAMES = [S.current.operationTypeBuy, S.current.operationTypeSell]; // ignore: non_constant_identifier_names

enum MoneyOperationType {deposit, withdraw, buy, sell}  // buy and sell is only for non-money operations (i.e. buying and selling securities)
List MONEY_OPERATION_TYPE_NAMES = [S.current.moneyOperationTypeDeposit, S.current.moneyOperationTypeWithdraw]; // ignore: non_constant_identifier_names

const EdgeInsets PANEL_PADDING = EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0);
const EdgeInsets PANEL_MARGIN = EdgeInsets.all(6.0);
const EdgeInsets EDIT_UNDERLINE_PADDING = EdgeInsets.all(3.0);


bool isKeyboardOpen(BuildContext context) => MediaQuery.of(context).viewInsets.bottom == 0.0;

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

DateTime todayDate() {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

void commonInit() {
  // dummy function to init variables in the module like INSTRUMENT_TYPE_NAMES and others
}