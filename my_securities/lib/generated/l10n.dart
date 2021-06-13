// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Settings`
  String get appBar_settings {
    return Intl.message(
      'Settings',
      name: 'appBar_settings',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get dialogAction_yes {
    return Intl.message(
      'Yes',
      name: 'dialogAction_yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get dialogAction_no {
    return Intl.message(
      'No',
      name: 'dialogAction_no',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get dialogAction_Ok {
    return Intl.message(
      'OK',
      name: 'dialogAction_Ok',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get dialogAction_Cancel {
    return Intl.message(
      'Cancel',
      name: 'dialogAction_Cancel',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get dialogAction_Continue {
    return Intl.message(
      'Continue',
      name: 'dialogAction_Continue',
      desc: '',
      args: [],
    );
  }

  /// `Invalid value`
  String get errorInvalidValue {
    return Intl.message(
      'Invalid value',
      name: 'errorInvalidValue',
      desc: '',
      args: [],
    );
  }

  /// `My securities`
  String get applicationTitle {
    return Intl.message(
      'My securities',
      name: 'applicationTitle',
      desc: '',
      args: [],
    );
  }

  /// `My portfolio`
  String get defaultPortfolioName {
    return Intl.message(
      'My portfolio',
      name: 'defaultPortfolioName',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get operationTypeBuy {
    return Intl.message(
      'Buy',
      name: 'operationTypeBuy',
      desc: '',
      args: [],
    );
  }

  /// `Sell`
  String get operationTypeSell {
    return Intl.message(
      'Sell',
      name: 'operationTypeSell',
      desc: '',
      args: [],
    );
  }

  /// `Deposit`
  String get moneyOperationTypeDeposit {
    return Intl.message(
      'Deposit',
      name: 'moneyOperationTypeDeposit',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw`
  String get moneyOperationTypeWithdraw {
    return Intl.message(
      'Withdraw',
      name: 'moneyOperationTypeWithdraw',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get instrumentTypeCurrency {
    return Intl.message(
      'Currency',
      name: 'instrumentTypeCurrency',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get instrumentTypeShare {
    return Intl.message(
      'Share',
      name: 'instrumentTypeShare',
      desc: '',
      args: [],
    );
  }

  /// `Etf`
  String get instrumentTypeEtf {
    return Intl.message(
      'Etf',
      name: 'instrumentTypeEtf',
      desc: '',
      args: [],
    );
  }

  /// `Bond`
  String get instrumentTypeBond {
    return Intl.message(
      'Bond',
      name: 'instrumentTypeBond',
      desc: '',
      args: [],
    );
  }

  /// `pcs`
  String get pcs {
    return Intl.message(
      'pcs',
      name: 'pcs',
      desc: '',
      args: [],
    );
  }

  /// `Portfolio '{name}' already exists`
  String db_portfolioAlreadyExists(Object name) {
    return Intl.message(
      'Portfolio \'$name\' already exists',
      name: 'db_portfolioAlreadyExists',
      desc: '',
      args: [name],
    );
  }

  /// `Portfolio is not empty`
  String get db_portfolioNotEmpty {
    return Intl.message(
      'Portfolio is not empty',
      name: 'db_portfolioNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Started`
  String get portfoliosListView_portfolioStarted {
    return Intl.message(
      'Started',
      name: 'portfoliosListView_portfolioStarted',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get portfoliosListView_menuEdit {
    return Intl.message(
      'Edit',
      name: 'portfoliosListView_menuEdit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get portfoliosListView_menuDelete {
    return Intl.message(
      'Delete',
      name: 'portfoliosListView_menuDelete',
      desc: '',
      args: [],
    );
  }

  /// `Visible`
  String get portfoliosListView_menuVisible {
    return Intl.message(
      'Visible',
      name: 'portfoliosListView_menuVisible',
      desc: '',
      args: [],
    );
  }

  /// `Portfolio deletion`
  String get portfoliosListView_confirmDeleteDialogTitle {
    return Intl.message(
      'Portfolio deletion',
      name: 'portfoliosListView_confirmDeleteDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete portfolio '{name}'?`
  String portfoliosListView_confirmDeleteDialogContent(Object name) {
    return Intl.message(
      'Are you sure you want to delete portfolio \'$name\'?',
      name: 'portfoliosListView_confirmDeleteDialogContent',
      desc: '',
      args: [name],
    );
  }

  /// `Edit portfolio`
  String get portfolioEditDialog_Title {
    return Intl.message(
      'Edit portfolio',
      name: 'portfolioEditDialog_Title',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get portfolioEditDialog_Name {
    return Intl.message(
      'Name',
      name: 'portfolioEditDialog_Name',
      desc: '',
      args: [],
    );
  }

  /// `Creation date`
  String get portfolioEditDialog_startDate {
    return Intl.message(
      'Creation date',
      name: 'portfolioEditDialog_startDate',
      desc: '',
      args: [],
    );
  }

  /// `Add operation`
  String get portfolioInstrumentPageAddOperation {
    return Intl.message(
      'Add operation',
      name: 'portfolioInstrumentPageAddOperation',
      desc: '',
      args: [],
    );
  }

  /// `Add money operation`
  String get portfolioInstrumentPageAddMoneyOperation {
    return Intl.message(
      'Add money operation',
      name: 'portfolioInstrumentPageAddMoneyOperation',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get portfolioInstrumentListView_menuEdit {
    return Intl.message(
      'Edit',
      name: 'portfolioInstrumentListView_menuEdit',
      desc: '',
      args: [],
    );
  }

  /// `Instrument settings`
  String get portfolioInstrumentEditDialog_Title {
    return Intl.message(
      'Instrument settings',
      name: 'portfolioInstrumentEditDialog_Title',
      desc: '',
      args: [],
    );
  }

  /// `Percent in '{portfolio_name}' portfolio`
  String portfolioInstrumentEditDialog_percent(Object portfolio_name) {
    return Intl.message(
      'Percent in \'$portfolio_name\' portfolio',
      name: 'portfolioInstrumentEditDialog_percent',
      desc: '',
      args: [portfolio_name],
    );
  }

  /// `Edit`
  String get operationsListViewItem_menuEdit {
    return Intl.message(
      'Edit',
      name: 'operationsListViewItem_menuEdit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get operationsListViewItem_menuDelete {
    return Intl.message(
      'Delete',
      name: 'operationsListViewItem_menuDelete',
      desc: '',
      args: [],
    );
  }

  /// `Operation deletion`
  String get operationsListView_confirmDeleteDialogTitle {
    return Intl.message(
      'Operation deletion',
      name: 'operationsListView_confirmDeleteDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete operation '{description}'?`
  String operationsListView_confirmDeleteDialogContent(Object description) {
    return Intl.message(
      'Are you sure you want to delete operation \'$description\'?',
      name: 'operationsListView_confirmDeleteDialogContent',
      desc: '',
      args: [description],
    );
  }

  /// `{portfolio} operations`
  String portfolioOperations_Title(Object portfolio) {
    return Intl.message(
      '$portfolio operations',
      name: 'portfolioOperations_Title',
      desc: '',
      args: [portfolio],
    );
  }

  /// `Add operation`
  String get operationEditDialog_Title_add {
    return Intl.message(
      'Add operation',
      name: 'operationEditDialog_Title_add',
      desc: '',
      args: [],
    );
  }

  /// `Edit operation`
  String get operationEditDialog_Title_edit {
    return Intl.message(
      'Edit operation',
      name: 'operationEditDialog_Title_edit',
      desc: '',
      args: [],
    );
  }

  /// `Ticker`
  String get operationEditDialog_instrumentticker {
    return Intl.message(
      'Ticker',
      name: 'operationEditDialog_instrumentticker',
      desc: '',
      args: [],
    );
  }

  /// `Operation date`
  String get operationEditDialog_date {
    return Intl.message(
      'Operation date',
      name: 'operationEditDialog_date',
      desc: '',
      args: [],
    );
  }

  /// `Operation type`
  String get operationEditDialog_operationtype {
    return Intl.message(
      'Operation type',
      name: 'operationEditDialog_operationtype',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get operationEditDialog_quantity {
    return Intl.message(
      'Quantity',
      name: 'operationEditDialog_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get operationEditDialog_price {
    return Intl.message(
      'Price',
      name: 'operationEditDialog_price',
      desc: '',
      args: [],
    );
  }

  /// `Commission`
  String get operationEditDialog_commission {
    return Intl.message(
      'Commission',
      name: 'operationEditDialog_commission',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw money`
  String get operationEditDialog_withdrawmoney {
    return Intl.message(
      'Withdraw money',
      name: 'operationEditDialog_withdrawmoney',
      desc: '',
      args: [],
    );
  }

  /// `Match not found`
  String get operationEditDialog_notickersuggestion {
    return Intl.message(
      'Match not found',
      name: 'operationEditDialog_notickersuggestion',
      desc: '',
      args: [],
    );
  }

  /// `Not enough money for this operation`
  String get operationEditDialog_noenoughmoney {
    return Intl.message(
      'Not enough money for this operation',
      name: 'operationEditDialog_noenoughmoney',
      desc: '',
      args: [],
    );
  }

  /// `{portfolio} money operations`
  String portfolioMoneyOperations_Title(Object portfolio) {
    return Intl.message(
      '$portfolio money operations',
      name: 'portfolioMoneyOperations_Title',
      desc: '',
      args: [portfolio],
    );
  }

  /// `Add money operation`
  String get moneyOperationEditDialog_Title_add {
    return Intl.message(
      'Add money operation',
      name: 'moneyOperationEditDialog_Title_add',
      desc: '',
      args: [],
    );
  }

  /// `Edit money operation`
  String get moneyOperationEditDialog_Title_edit {
    return Intl.message(
      'Edit money operation',
      name: 'moneyOperationEditDialog_Title_edit',
      desc: '',
      args: [],
    );
  }

  /// `Operation date`
  String get moneyOperationEditDialog_date {
    return Intl.message(
      'Operation date',
      name: 'moneyOperationEditDialog_date',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get moneyOperationEditDialog_currency {
    return Intl.message(
      'Currency',
      name: 'moneyOperationEditDialog_currency',
      desc: '',
      args: [],
    );
  }

  /// `Operation type`
  String get moneyOperationEditDialog_operationtype {
    return Intl.message(
      'Operation type',
      name: 'moneyOperationEditDialog_operationtype',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get moneyOperationEditDialog_amount {
    return Intl.message(
      'Amount',
      name: 'moneyOperationEditDialog_amount',
      desc: '',
      args: [],
    );
  }

  /// `Main`
  String get prefTitleMain {
    return Intl.message(
      'Main',
      name: 'prefTitleMain',
      desc: '',
      args: [],
    );
  }

  /// `Main currency`
  String get prefMainCurrencyTitle {
    return Intl.message(
      'Main currency',
      name: 'prefMainCurrencyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get prefTitleAppearance {
    return Intl.message(
      'Appearance',
      name: 'prefTitleAppearance',
      desc: '',
      args: [],
    );
  }

  /// `Dark theme`
  String get prefDarkTheme {
    return Intl.message(
      'Dark theme',
      name: 'prefDarkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Show hidden portfolios`
  String get prefShowHiddenPortfoliosTitle {
    return Intl.message(
      'Show hidden portfolios',
      name: 'prefShowHiddenPortfoliosTitle',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}