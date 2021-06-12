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

  static m1(description) => "Вы уверены, что хотите удалить операцию \'${description}\'?";

  static m2(portfolio_name) => "Процент в портфеле \'${portfolio_name}\'";

  static m3(portfolio) => "Операции в ${portfolio}";

  static m4(name) => "Вы уверены, что хотите удалить портфель \'${name}\'?";

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
    "errorInvalidValue" : MessageLookupByLibrary.simpleMessage("Недопустимое значение"),
    "instrumentTypeBond" : MessageLookupByLibrary.simpleMessage("Облигация"),
    "instrumentTypeCurrency" : MessageLookupByLibrary.simpleMessage("Валюта"),
    "instrumentTypeEtf" : MessageLookupByLibrary.simpleMessage("Фонд"),
    "instrumentTypeShare" : MessageLookupByLibrary.simpleMessage("Акция"),
    "moneyOperationEditDialog_Title_add" : MessageLookupByLibrary.simpleMessage("Добавить операции с валютой"),
    "moneyOperationEditDialog_Title_edit" : MessageLookupByLibrary.simpleMessage("Редактировать операцию с валютой"),
    "moneyOperationEditDialog_amount" : MessageLookupByLibrary.simpleMessage("Сумма"),
    "moneyOperationEditDialog_currency" : MessageLookupByLibrary.simpleMessage("Валюта"),
    "moneyOperationEditDialog_date" : MessageLookupByLibrary.simpleMessage("Дата операции"),
    "moneyOperationEditDialog_operationtype" : MessageLookupByLibrary.simpleMessage("Тип операции"),
    "moneyOperationTypeDeposit" : MessageLookupByLibrary.simpleMessage("Поступление"),
    "moneyOperationTypeWithdraw" : MessageLookupByLibrary.simpleMessage("Вывод"),
    "operationEditDialog_Title_add" : MessageLookupByLibrary.simpleMessage("Добавить операцию"),
    "operationEditDialog_Title_edit" : MessageLookupByLibrary.simpleMessage("Редактировать операцию"),
    "operationEditDialog_commission" : MessageLookupByLibrary.simpleMessage("Комиссия"),
    "operationEditDialog_date" : MessageLookupByLibrary.simpleMessage("Дата операции"),
    "operationEditDialog_instrumentticker" : MessageLookupByLibrary.simpleMessage("Тикер"),
    "operationEditDialog_notickersuggestion" : MessageLookupByLibrary.simpleMessage("Соответствие не найдено"),
    "operationEditDialog_operationtype" : MessageLookupByLibrary.simpleMessage("Тип операции"),
    "operationEditDialog_price" : MessageLookupByLibrary.simpleMessage("Цена"),
    "operationEditDialog_quantity" : MessageLookupByLibrary.simpleMessage("Количество"),
    "operationEditDialog_withdrawmoney" : MessageLookupByLibrary.simpleMessage("Списать деньги"),
    "operationTypeBuy" : MessageLookupByLibrary.simpleMessage("Покупка"),
    "operationTypeSell" : MessageLookupByLibrary.simpleMessage("Продажа"),
    "operationsListViewItem_menuDelete" : MessageLookupByLibrary.simpleMessage("Удалить"),
    "operationsListViewItem_menuEdit" : MessageLookupByLibrary.simpleMessage("Редактировать"),
    "operationsListView_confirmDeleteDialogContent" : m1,
    "operationsListView_confirmDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("Удаление операции"),
    "pcs" : MessageLookupByLibrary.simpleMessage("шт"),
    "portfolioEditDialog_Name" : MessageLookupByLibrary.simpleMessage("Наименование"),
    "portfolioEditDialog_Title" : MessageLookupByLibrary.simpleMessage("Редактировать портфель"),
    "portfolioEditDialog_startDate" : MessageLookupByLibrary.simpleMessage("Дата создания"),
    "portfolioInstrumentEditDialog_Title" : MessageLookupByLibrary.simpleMessage("Настройка инструмента"),
    "portfolioInstrumentEditDialog_percent" : m2,
    "portfolioInstrumentListView_menuEdit" : MessageLookupByLibrary.simpleMessage("Редактировать"),
    "portfolioInstrumentPageAddMoneyOperation" : MessageLookupByLibrary.simpleMessage("Добавить операцию с валютой"),
    "portfolioInstrumentPageAddOperation" : MessageLookupByLibrary.simpleMessage("Добавить операцию"),
    "portfolioOperations_Title" : m3,
    "portfoliosListView_confirmDeleteDialogContent" : m4,
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
