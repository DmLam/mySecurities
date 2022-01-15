import 'package:flutter/material.dart';

import 'generated/l10n.dart';

const CURRENT_PRICE_CACHE_TIME = 60; // seconds

final INSTRUMENT_TYPE_NAMES = [S.current.instrumentTypeCurrency, S.current.instrumentTypeShare, S.current.instrumentTypeEtf,
  S.current.instrumentTypeBond, S.current.instrumentTypeFutures, S.current.instrumentTypeIndex,
  S.current.instrumentTypeDepositaryReceipt];
final OPERATION_TYPE_NAMES = [S.current.operationTypeBuy, S.current.operationTypeSell];
final MONEY_OPERATION_TYPE_NAMES = [S.current.moneyOperationTypeDeposit, S.current.moneyOperationTypeWithdraw,
  S.current.moneyOperationTypeBuy, S.current.moneyOperationTypeSell,
  S.current.moneyOperationTypeCommission];

// ui constants
const EdgeInsets EDIT_UNDERLINE_PADDING = EdgeInsets.all(3.0);

// dummy function to init variables in the module like INSTRUMENT_TYPE_NAMES and others
void constantsInit() {

}