import 'package:flutter/material.dart';

import 'generated/l10n.dart';

const CURRENT_PRICE_CACHE_TIME = 60; // seconds

final List INSTRUMENT_TYPE_NAMES = [S.current.instrumentTypeCurrency, S.current.instrumentTypeShare, S.current.instrumentTypeEtf, S.current.instrumentTypeBond]; // ignore: non_constant_identifier_names
final List OPERATION_TYPE_NAMES = [S.current.operationTypeBuy, S.current.operationTypeSell]; // ignore: non_constant_identifier_names
final List MONEY_OPERATION_TYPE_NAMES = [S.current.moneyOperationTypeDeposit, S.current.moneyOperationTypeWithdraw]; // ignore: non_constant_identifier_names

// ui constants
const EdgeInsets EDIT_UNDERLINE_PADDING = EdgeInsets.all(3.0);

void constantsInit() {
  // dummy function to init variables in the module like INSTRUMENT_TYPE_NAMES and others
}