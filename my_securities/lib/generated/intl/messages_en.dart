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

  static m2(portfolio_name) => "Percent in \'${portfolio_name}\' portfolio";

  static m3(portfolio) => "${portfolio} operations";

  static m4(name) => "Are you sure you want to delete portfolio \'${name}\'?";

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
    "instrumentTypeBond" : MessageLookupByLibrary.simpleMessage("Bond"),
    "instrumentTypeCurrency" : MessageLookupByLibrary.simpleMessage("Currency"),
    "instrumentTypeEtf" : MessageLookupByLibrary.simpleMessage("Etf"),
    "instrumentTypeShare" : MessageLookupByLibrary.simpleMessage("Share"),
    "moneyOperationTypeDeposit" : MessageLookupByLibrary.simpleMessage("Deposit"),
    "moneyOperationTypeWithdraw" : MessageLookupByLibrary.simpleMessage("Withdraw"),
    "operationEditDialog_Title_add" : MessageLookupByLibrary.simpleMessage("Add operation"),
    "operationEditDialog_Title_edit" : MessageLookupByLibrary.simpleMessage("Edit operation"),
    "operationEditDialog_commission" : MessageLookupByLibrary.simpleMessage("Commission"),
    "operationEditDialog_date" : MessageLookupByLibrary.simpleMessage("Operation date"),
    "operationEditDialog_instrumentticker" : MessageLookupByLibrary.simpleMessage("Ticker"),
    "operationEditDialog_notickersuggestion" : MessageLookupByLibrary.simpleMessage("Match not found"),
    "operationEditDialog_operationtype" : MessageLookupByLibrary.simpleMessage("Operation type"),
    "operationEditDialog_price" : MessageLookupByLibrary.simpleMessage("Price"),
    "operationEditDialog_quantity" : MessageLookupByLibrary.simpleMessage("Quantity"),
    "operationEditDialog_withdrawmoney" : MessageLookupByLibrary.simpleMessage("Withdraw money"),
    "operationTypeBuy" : MessageLookupByLibrary.simpleMessage("Buy"),
    "operationTypeSell" : MessageLookupByLibrary.simpleMessage("Sell"),
    "operationsListViewItem_menuDelete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "operationsListViewItem_menuEdit" : MessageLookupByLibrary.simpleMessage("Edit"),
    "operationsListView_confirmDeleteDialogContent" : m1,
    "operationsListView_confirmDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("Operation deletion"),
    "pcs" : MessageLookupByLibrary.simpleMessage("pcs"),
    "portfolioEditDialog_Name" : MessageLookupByLibrary.simpleMessage("Name"),
    "portfolioEditDialog_Title" : MessageLookupByLibrary.simpleMessage("Edit portfolio"),
    "portfolioEditDialog_startDate" : MessageLookupByLibrary.simpleMessage("Creation date"),
    "portfolioInstrumentEditDialog_Title" : MessageLookupByLibrary.simpleMessage("Instrument settings"),
    "portfolioInstrumentEditDialog_percent" : m2,
    "portfolioInstrumentListView_menuEdit" : MessageLookupByLibrary.simpleMessage("Edit"),
    "portfolioOperations_Title" : m3,
    "portfoliosListView_confirmDeleteDialogContent" : m4,
    "portfoliosListView_confirmDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("Portfolio deletion"),
    "portfoliosListView_menuDelete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "portfoliosListView_menuEdit" : MessageLookupByLibrary.simpleMessage("Edit"),
    "portfoliosListView_menuVisible" : MessageLookupByLibrary.simpleMessage("Visible"),
    "portfoliosListView_portfolioStarted" : MessageLookupByLibrary.simpleMessage("Started"),
    "prefDarkTheme" : MessageLookupByLibrary.simpleMessage("Dark theme"),
    "prefMainCurrencyTitle" : MessageLookupByLibrary.simpleMessage("Main currency"),
    "prefShowHiddenPortfoliosTitle" : MessageLookupByLibrary.simpleMessage("Show hidden portfolios"),
    "prefTitleAppearance" : MessageLookupByLibrary.simpleMessage("Appearance"),
    "prefTitleMain" : MessageLookupByLibrary.simpleMessage("Main")
  };
}
