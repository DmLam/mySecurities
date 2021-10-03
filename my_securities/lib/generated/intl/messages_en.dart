// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(name) => "Portfolio \'${name}\' already exists";

  static m1(description) => "Are you sure you want to delete operation \'${description}\'?";

  static m2(description) => "Are you sure you want to delete operation \'${description}\'?";

  static m3(portfolio_name) => "Commission for \'${portfolio_name}\' portfolio";

  static m4(portfolio_name) => "Percent in \'${portfolio_name}\' portfolio";

  static m5(portfolio) => "${portfolio} money operations";

  static m6(portfolio) => "${portfolio} operations";

  static m7(name) => "Are you sure you want to delete portfolio \'${name}\'?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "appBar_settings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "applicationTitle" : MessageLookupByLibrary.simpleMessage("My securities"),
    "db_portfolioAlreadyExists" : m0,
    "db_portfolioNotEmpty" : MessageLookupByLibrary.simpleMessage("Portfolio is not empty"),
    "defaultPortfolioName" : MessageLookupByLibrary.simpleMessage("My portfolio"),
    "dialogAction_Cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "dialogAction_Continue" : MessageLookupByLibrary.simpleMessage("Continue"),
    "dialogAction_Ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "dialogAction_no" : MessageLookupByLibrary.simpleMessage("No"),
    "dialogAction_yes" : MessageLookupByLibrary.simpleMessage("Yes"),
    "errorInvalidValue" : MessageLookupByLibrary.simpleMessage("Invalid value"),
    "errorNoCurrency" : MessageLookupByLibrary.simpleMessage("There is no money in the instrument\'s currency"),
    "errorNotEnoughMoney" : MessageLookupByLibrary.simpleMessage("There is not enough money to purchase"),
    "instrumentTypeBond" : MessageLookupByLibrary.simpleMessage("Bond"),
    "instrumentTypeCurrency" : MessageLookupByLibrary.simpleMessage("Currency"),
    "instrumentTypeDepositaryReceipt" : MessageLookupByLibrary.simpleMessage("Depositary receipt"),
    "instrumentTypeEtf" : MessageLookupByLibrary.simpleMessage("Etf"),
    "instrumentTypeFutures" : MessageLookupByLibrary.simpleMessage("Futures"),
    "instrumentTypeIndex" : MessageLookupByLibrary.simpleMessage("Stock index"),
    "instrumentTypeShare" : MessageLookupByLibrary.simpleMessage("Share"),
    "moneyOperationEditDialog_Title_add" : MessageLookupByLibrary.simpleMessage("Add money operation"),
    "moneyOperationEditDialog_Title_edit" : MessageLookupByLibrary.simpleMessage("Edit money operation"),
    "moneyOperationEditDialog_amount" : MessageLookupByLibrary.simpleMessage("Amount"),
    "moneyOperationEditDialog_currency" : MessageLookupByLibrary.simpleMessage("Currency"),
    "moneyOperationEditDialog_date" : MessageLookupByLibrary.simpleMessage("Operation date"),
    "moneyOperationEditDialog_operationtype" : MessageLookupByLibrary.simpleMessage("Operation type"),
    "moneyOperationTypeBuy" : MessageLookupByLibrary.simpleMessage("Buy"),
    "moneyOperationTypeCommission" : MessageLookupByLibrary.simpleMessage("Commission"),
    "moneyOperationTypeDeposit" : MessageLookupByLibrary.simpleMessage("Deposit"),
    "moneyOperationTypeSell" : MessageLookupByLibrary.simpleMessage("Sell"),
    "moneyOperationTypeWithdraw" : MessageLookupByLibrary.simpleMessage("Withdraw"),
    "moneyOperationsListView_confirmDeleteDialogContent" : m1,
    "moneyOperationsListView_confirmDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("Operation deletion"),
    "moneyOperationsListView_menuDelete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "moneyOperationsListView_menuEdit" : MessageLookupByLibrary.simpleMessage("Edit"),
    "operationEditDialog_Title_add" : MessageLookupByLibrary.simpleMessage("Add operation"),
    "operationEditDialog_Title_edit" : MessageLookupByLibrary.simpleMessage("Edit operation"),
    "operationEditDialog_comment" : MessageLookupByLibrary.simpleMessage("Comment"),
    "operationEditDialog_commission" : MessageLookupByLibrary.simpleMessage("Commission"),
    "operationEditDialog_date" : MessageLookupByLibrary.simpleMessage("Operation date"),
    "operationEditDialog_instrumentticker" : MessageLookupByLibrary.simpleMessage("Ticker"),
    "operationEditDialog_noenoughmoney" : MessageLookupByLibrary.simpleMessage("Not enough money for this operation"),
    "operationEditDialog_notickersuggestion" : MessageLookupByLibrary.simpleMessage("Match not found"),
    "operationEditDialog_operationtype" : MessageLookupByLibrary.simpleMessage("Operation type"),
    "operationEditDialog_price" : MessageLookupByLibrary.simpleMessage("Price"),
    "operationEditDialog_quantity" : MessageLookupByLibrary.simpleMessage("Quantity"),
    "operationEditDialog_withdrawmoney" : MessageLookupByLibrary.simpleMessage("Withdraw money"),
    "operationTypeBuy" : MessageLookupByLibrary.simpleMessage("Buy"),
    "operationTypeSell" : MessageLookupByLibrary.simpleMessage("Sell"),
    "operationsListViewItem_menuDelete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "operationsListViewItem_menuEdit" : MessageLookupByLibrary.simpleMessage("Edit"),
    "operationsListView_confirmDeleteDialogContent" : m2,
    "operationsListView_confirmDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("Operation deletion"),
    "pcs" : MessageLookupByLibrary.simpleMessage("pcs"),
    "portfolioEditDialog_Commission" : MessageLookupByLibrary.simpleMessage("Commission"),
    "portfolioEditDialog_Name" : MessageLookupByLibrary.simpleMessage("Name"),
    "portfolioEditDialog_Title" : MessageLookupByLibrary.simpleMessage("Edit portfolio"),
    "portfolioEditDialog_startDate" : MessageLookupByLibrary.simpleMessage("Creation date"),
    "portfolioEditDialog_visible" : MessageLookupByLibrary.simpleMessage("Visible"),
    "portfolioInstrumentEditDialog_Title" : MessageLookupByLibrary.simpleMessage("Instrument settings"),
    "portfolioInstrumentEditDialog_commission" : m3,
    "portfolioInstrumentEditDialog_percent" : m4,
    "portfolioInstrumentListView_menuEdit" : MessageLookupByLibrary.simpleMessage("Edit"),
    "portfolioInstrumentPageAddMoneyOperation" : MessageLookupByLibrary.simpleMessage("Add money operation"),
    "portfolioInstrumentPageAddOperation" : MessageLookupByLibrary.simpleMessage("Add operation"),
    "portfolioMoneyOperations_Title" : m5,
    "portfolioOperations_Title" : m6,
    "portfoliosListView_confirmDeleteDialogContent" : m7,
    "portfoliosListView_confirmDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("Portfolio deletion"),
    "portfoliosListView_menuDelete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "portfoliosListView_menuEdit" : MessageLookupByLibrary.simpleMessage("Edit"),
    "portfoliosListView_portfolioStarted" : MessageLookupByLibrary.simpleMessage("Started"),
    "prefDarkTheme" : MessageLookupByLibrary.simpleMessage("Dark theme"),
    "prefHideSoldInstruments" : MessageLookupByLibrary.simpleMessage("Hide sold instruments"),
    "prefMainCurrencyTitle" : MessageLookupByLibrary.simpleMessage("Main currency"),
    "prefShowHiddenPortfoliosTitle" : MessageLookupByLibrary.simpleMessage("Show hidden portfolios"),
    "prefTitleAppearance" : MessageLookupByLibrary.simpleMessage("Appearance"),
    "prefTitleMain" : MessageLookupByLibrary.simpleMessage("Main")
  };
}
