// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(name) => "Портфель ${name} уже существует";

  static String m1(portfolio_name) => "Импорт операций ${portfolio_name}";

  static String m2(description) =>
      "Вы уверены, что хотите удалить операцию \'${description}\'?";

  static String m3(portfolio, ticker) => "Операции по ${ticker} в ${portfolio}";

  static String m4(description) =>
      "Вы уверены, что хотите удалить операцию \'${description}\'?";

  static String m5(portfolio_name) =>
      "Комиссия для портфеля \'${portfolio_name}\'";

  static String m6(portfolio_name) =>
      "Процент в портфеле \'${portfolio_name}\'";

  static String m7(portfolio) => "Операции с валютой в ${portfolio}";

  static String m8(portfolio) => "Операции в ${portfolio}";

  static String m9(name) =>
      "Вы уверены, что хотите удалить портфель \'${name}\'?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appBar_settings": MessageLookupByLibrary.simpleMessage("Настройки"),
        "applicationTitle":
            MessageLookupByLibrary.simpleMessage("My securities"),
        "db_portfolioAlreadyExists": m0,
        "db_portfolioNotEmpty":
            MessageLookupByLibrary.simpleMessage("Портфель не пуст"),
        "defaultPortfolioName":
            MessageLookupByLibrary.simpleMessage("Мой портфель"),
        "dialogAction_Cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "dialogAction_Continue":
            MessageLookupByLibrary.simpleMessage("Продолжить"),
        "dialogAction_Ok": MessageLookupByLibrary.simpleMessage("OK"),
        "dialogAction_no": MessageLookupByLibrary.simpleMessage("Нет"),
        "dialogAction_yes": MessageLookupByLibrary.simpleMessage("Да"),
        "errorInvalidValue":
            MessageLookupByLibrary.simpleMessage("Недопустимое значение"),
        "errorNoCurrency": MessageLookupByLibrary.simpleMessage(
            "Отсутствуют средства в валюте инструмента"),
        "errorNotEnoughMoney": MessageLookupByLibrary.simpleMessage(
            "Недостаточно средств для покупки"),
        "importPortfolioOperationsPageSelectFile":
            MessageLookupByLibrary.simpleMessage(
                "Выберите xlsx-файл для загрузки"),
        "importPortfolioOperationsPageTitle": m1,
        "instrumentTypeBond": MessageLookupByLibrary.simpleMessage("Облигация"),
        "instrumentTypeCurrency":
            MessageLookupByLibrary.simpleMessage("Валюта"),
        "instrumentTypeDepositaryReceipt":
            MessageLookupByLibrary.simpleMessage("Депозитарная расписка"),
        "instrumentTypeEtf": MessageLookupByLibrary.simpleMessage("Фонд"),
        "instrumentTypeFutures":
            MessageLookupByLibrary.simpleMessage("Фьючерс"),
        "instrumentTypeIndex": MessageLookupByLibrary.simpleMessage("Индеск"),
        "instrumentTypeShare": MessageLookupByLibrary.simpleMessage("Акция"),
        "moneyOperationEditDialog_Title_add":
            MessageLookupByLibrary.simpleMessage("Добавить операции с валютой"),
        "moneyOperationEditDialog_Title_edit":
            MessageLookupByLibrary.simpleMessage(
                "Редактировать операцию с валютой"),
        "moneyOperationEditDialog_amount":
            MessageLookupByLibrary.simpleMessage("Сумма"),
        "moneyOperationEditDialog_currency":
            MessageLookupByLibrary.simpleMessage("Валюта"),
        "moneyOperationEditDialog_date":
            MessageLookupByLibrary.simpleMessage("Дата операции"),
        "moneyOperationEditDialog_operationtype":
            MessageLookupByLibrary.simpleMessage("Тип операции"),
        "moneyOperationTypeBuy":
            MessageLookupByLibrary.simpleMessage("Покупка"),
        "moneyOperationTypeCommission":
            MessageLookupByLibrary.simpleMessage("Комиссия"),
        "moneyOperationTypeDeposit":
            MessageLookupByLibrary.simpleMessage("Поступление"),
        "moneyOperationTypeSell":
            MessageLookupByLibrary.simpleMessage("Продажа"),
        "moneyOperationTypeWithdraw":
            MessageLookupByLibrary.simpleMessage("Вывод"),
        "moneyOperationsListView_confirmDeleteDialogContent": m2,
        "moneyOperationsListView_confirmDeleteDialogTitle":
            MessageLookupByLibrary.simpleMessage("Удаление операции"),
        "moneyOperationsListView_menuDelete":
            MessageLookupByLibrary.simpleMessage("Удалить"),
        "moneyOperationsListView_menuEdit":
            MessageLookupByLibrary.simpleMessage("Редактировать"),
        "operationEditDialog_Title_add":
            MessageLookupByLibrary.simpleMessage("Добавить операцию"),
        "operationEditDialog_Title_edit":
            MessageLookupByLibrary.simpleMessage("Редактировать операцию"),
        "operationEditDialog_comment":
            MessageLookupByLibrary.simpleMessage("Комментарий"),
        "operationEditDialog_commission":
            MessageLookupByLibrary.simpleMessage("Комиссия"),
        "operationEditDialog_date":
            MessageLookupByLibrary.simpleMessage("Дата операции"),
        "operationEditDialog_instrumentticker":
            MessageLookupByLibrary.simpleMessage("Тикер"),
        "operationEditDialog_noenoughmoney":
            MessageLookupByLibrary.simpleMessage(
                "Недостаточно средств для проведения операции"),
        "operationEditDialog_notickersuggestion":
            MessageLookupByLibrary.simpleMessage("Соответствие не найдено"),
        "operationEditDialog_operationtype":
            MessageLookupByLibrary.simpleMessage("Тип операции"),
        "operationEditDialog_price":
            MessageLookupByLibrary.simpleMessage("Цена"),
        "operationEditDialog_quantity":
            MessageLookupByLibrary.simpleMessage("Количество"),
        "operationEditDialog_withdrawmoney":
            MessageLookupByLibrary.simpleMessage("Списать деньги"),
        "operationTypeBuy": MessageLookupByLibrary.simpleMessage("Покупка"),
        "operationTypeSell": MessageLookupByLibrary.simpleMessage("Продажа"),
        "operationsByInstrument_Title": m3,
        "operationsListViewItem_menuDelete":
            MessageLookupByLibrary.simpleMessage("Удалить"),
        "operationsListViewItem_menuEdit":
            MessageLookupByLibrary.simpleMessage("Редактировать"),
        "operationsListView_confirmDeleteDialogContent": m4,
        "operationsListView_confirmDeleteDialogTitle":
            MessageLookupByLibrary.simpleMessage("Удаление операции"),
        "pcs": MessageLookupByLibrary.simpleMessage("шт"),
        "portfolioEditDialog_Commission":
            MessageLookupByLibrary.simpleMessage("Коммиссия"),
        "portfolioEditDialog_Name":
            MessageLookupByLibrary.simpleMessage("Наименование"),
        "portfolioEditDialog_Title":
            MessageLookupByLibrary.simpleMessage("Редактировать портфель"),
        "portfolioEditDialog_startDate":
            MessageLookupByLibrary.simpleMessage("Дата создания"),
        "portfolioEditDialog_visible":
            MessageLookupByLibrary.simpleMessage("Видимый"),
        "portfolioInstrumentEditDialog_Title":
            MessageLookupByLibrary.simpleMessage("Настройка инструмента"),
        "portfolioInstrumentEditDialog_commission": m5,
        "portfolioInstrumentEditDialog_percent": m6,
        "portfolioInstrumentListView_menuEdit":
            MessageLookupByLibrary.simpleMessage("Редактировать"),
        "portfolioInstrumentPageAddMoneyOperation":
            MessageLookupByLibrary.simpleMessage("Добавить операцию с валютой"),
        "portfolioInstrumentPageAddOperation":
            MessageLookupByLibrary.simpleMessage("Добавить операцию"),
        "portfolioInstrumentPageMenuImportOperations":
            MessageLookupByLibrary.simpleMessage("Импортировать операции"),
        "portfolioMoneyOperations_Title": m7,
        "portfolioOperations_Title": m8,
        "portfoliosListView_confirmDeleteDialogContent": m9,
        "portfoliosListView_confirmDeleteDialogTitle":
            MessageLookupByLibrary.simpleMessage("Удаление портфеля"),
        "portfoliosListView_menuDelete":
            MessageLookupByLibrary.simpleMessage("Удалить"),
        "portfoliosListView_menuEdit":
            MessageLookupByLibrary.simpleMessage("Редактировать"),
        "portfoliosListView_portfolioStarted":
            MessageLookupByLibrary.simpleMessage("Начат"),
        "prefDarkTheme": MessageLookupByLibrary.simpleMessage("Темная тема"),
        "prefHideSoldInstruments": MessageLookupByLibrary.simpleMessage(
            "Скрывать проданные инструменты"),
        "prefMainCurrencyTitle":
            MessageLookupByLibrary.simpleMessage("Основная валюта"),
        "prefShowHiddenPortfoliosTitle":
            MessageLookupByLibrary.simpleMessage("Показывать скрытые портфели"),
        "prefTitleAppearance":
            MessageLookupByLibrary.simpleMessage("Внешний вид"),
        "prefTitleMain": MessageLookupByLibrary.simpleMessage("Основные")
      };
}
