// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
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
  String get localeName => 'ru';

  static m0(name) => "Портфель ${name} уже существует";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "appBar_settings" : MessageLookupByLibrary.simpleMessage("Настройки"),
    "db_portfolioAlreadyExists" : m0,
    "db_portfolioNotEmpty" : MessageLookupByLibrary.simpleMessage("Портфель не пуст"),
    "defaultPortfolioName" : MessageLookupByLibrary.simpleMessage("Мой портфель"),
    "instrumentTypeBond" : MessageLookupByLibrary.simpleMessage("Облигация"),
    "instrumentTypeCurrency" : MessageLookupByLibrary.simpleMessage("Валюта"),
    "instrumentTypeEtf" : MessageLookupByLibrary.simpleMessage("Фонд"),
    "instrumentTypeShare" : MessageLookupByLibrary.simpleMessage("Акция"),
    "moneyOperationTypeDeposit" : MessageLookupByLibrary.simpleMessage("Поступление"),
    "moneyOperationTypeWithdraw" : MessageLookupByLibrary.simpleMessage("Вывод"),
    "operationTypeBuy" : MessageLookupByLibrary.simpleMessage("Покупка"),
    "operationTypeSell" : MessageLookupByLibrary.simpleMessage("Продажа"),
    "pcs" : MessageLookupByLibrary.simpleMessage("шт"),
    "portfolioEditDialog_Name" : MessageLookupByLibrary.simpleMessage("Наименование"),
    "portfolioEditDialog_startDate" : MessageLookupByLibrary.simpleMessage("Дата создания"),
    "portfolioListView_menuDelete" : MessageLookupByLibrary.simpleMessage("Удалить"),
    "portfolioListView_menuEdit" : MessageLookupByLibrary.simpleMessage("Редактировать"),
    "portfolioListView_portfolioStarted" : MessageLookupByLibrary.simpleMessage("Начат")
  };
}
