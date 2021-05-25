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

  static m1(portfolio_name) => "Процент в портфеле \'${portfolio_name}\'";

  static m2(name) => "Вы уверены, что хотите удалить портфель \'${name}\'?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "appBar_settings" : MessageLookupByLibrary.simpleMessage("Настройки"),
    "applicationTitle" : MessageLookupByLibrary.simpleMessage("My securities"),
    "db_portfolioAlreadyExists" : m0,
    "db_portfolioNotEmpty" : MessageLookupByLibrary.simpleMessage("Портфель не пуст"),
    "defaultPortfolioName" : MessageLookupByLibrary.simpleMessage("Мой портфель"),
    "dialogAction_Cancel" : MessageLookupByLibrary.simpleMessage("Отмена"),
    "dialogAction_Continue" : MessageLookupByLibrary.simpleMessage("Продолжить"),
    "dialogAction_Ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "dialogAction_no" : MessageLookupByLibrary.simpleMessage("Нет"),
    "dialogAction_yes" : MessageLookupByLibrary.simpleMessage("Да"),
    "instrumentTypeBond" : MessageLookupByLibrary.simpleMessage("Облигация"),
    "instrumentTypeCurrency" : MessageLookupByLibrary.simpleMessage("Валюта"),
    "instrumentTypeEtf" : MessageLookupByLibrary.simpleMessage("Фонд"),
    "instrumentTypeShare" : MessageLookupByLibrary.simpleMessage("Акция"),
    "moneyOperationTypeDeposit" : MessageLookupByLibrary.simpleMessage("Поступление"),
    "moneyOperationTypeWithdraw" : MessageLookupByLibrary.simpleMessage("Вывод"),
    "operationEditDialog_Title_add" : MessageLookupByLibrary.simpleMessage("Добавить операцию"),
    "operationEditDialog_Title_edit" : MessageLookupByLibrary.simpleMessage("Редактировать операцию"),
    "operationEditDialog_date" : MessageLookupByLibrary.simpleMessage("Дата операции"),
    "operationEditDialog_operationtype" : MessageLookupByLibrary.simpleMessage("Тип операции"),
    "operationTypeBuy" : MessageLookupByLibrary.simpleMessage("Покупка"),
    "operationTypeSell" : MessageLookupByLibrary.simpleMessage("Продажа"),
    "operationsListViewItem_menuDelete" : MessageLookupByLibrary.simpleMessage("Удалить"),
    "operationsListViewItem_menuEdit" : MessageLookupByLibrary.simpleMessage("Редактировать"),
    "pcs" : MessageLookupByLibrary.simpleMessage("шт"),
    "portfolioEditDialog_Name" : MessageLookupByLibrary.simpleMessage("Наименование"),
    "portfolioEditDialog_Title" : MessageLookupByLibrary.simpleMessage("Редактировать портфель"),
    "portfolioEditDialog_startDate" : MessageLookupByLibrary.simpleMessage("Дата создания"),
    "portfolioInstrumentEditDialog_Title" : MessageLookupByLibrary.simpleMessage("Настройка инструмента"),
    "portfolioInstrumentEditDialog_percent" : m1,
    "portfolioInstrumentListView_menuEdit" : MessageLookupByLibrary.simpleMessage("Редактировать"),
    "portfolioOperations_Title" : MessageLookupByLibrary.simpleMessage("Операции в портфеле"),
    "portfoliosListView_confirmDeleteDialogContent" : m2,
    "portfoliosListView_confirmDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("Удаление портфеля"),
    "portfoliosListView_menuDelete" : MessageLookupByLibrary.simpleMessage("Удалить"),
    "portfoliosListView_menuEdit" : MessageLookupByLibrary.simpleMessage("Редактировать"),
    "portfoliosListView_menuVisible" : MessageLookupByLibrary.simpleMessage("Видимый"),
    "portfoliosListView_portfolioStarted" : MessageLookupByLibrary.simpleMessage("Начат"),
    "prefDarkTheme" : MessageLookupByLibrary.simpleMessage("Темная тема"),
    "prefMainCurrencyTitle" : MessageLookupByLibrary.simpleMessage("Основная валюта"),
    "prefShowHiddenPortfoliosTitle" : MessageLookupByLibrary.simpleMessage("Показывать скрытые портфели"),
    "prefTitleAppearance" : MessageLookupByLibrary.simpleMessage("Внешний вид"),
    "prefTitleMain" : MessageLookupByLibrary.simpleMessage("Основные")
  };
}
