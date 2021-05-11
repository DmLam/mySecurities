import 'package:flutter/material.dart';
import 'generated/l10n.dart';

const CURRENT_PRICE_CACHE_TIME = 60; // seconds

final List INSTRUMENT_TYPE_NAMES = [S.current.instrumentTypeCurrency, S.current.instrumentTypeShare, S.current.instrumentTypeEtf, S.current.instrumentTypeBond]; // ignore: non_constant_identifier_names
final List OPERATION_TYPE_NAMES = [S.current.operationTypeBuy, S.current.operationTypeSell]; // ignore: non_constant_identifier_names
final List MONEY_OPERATION_TYPE_NAMES = [S.current.moneyOperationTypeDeposit, S.current.moneyOperationTypeWithdraw]; // ignore: non_constant_identifier_names

// names for preferences
final String pref_MAIN_CURRENCY_ID = 'main_currency_id'; // ignore: non_constant_identifier_names
final String pref_SHOW_HIDDEN_PORTFOLIOS = 'show_hidden_portfolios'; // ignore: non_constant_identifier_names

void constantsInit() {
  // dummy function to init variables in the module like INSTRUMENT_TYPE_NAMES and others
}