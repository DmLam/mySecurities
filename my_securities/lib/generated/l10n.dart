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
  String get portfolioListView_portfolioStarted {
    return Intl.message(
      'Started',
      name: 'portfolioListView_portfolioStarted',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get portfolioListView_menuEdit {
    return Intl.message(
      'Edit',
      name: 'portfolioListView_menuEdit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get portfolioListView_menuDelete {
    return Intl.message(
      'Delete',
      name: 'portfolioListView_menuDelete',
      desc: '',
      args: [],
    );
  }

  /// `Visible`
  String get portfolioListView_menuVisible {
    return Intl.message(
      'Visible',
      name: 'portfolioListView_menuVisible',
      desc: '',
      args: [],
    );
  }

  /// `Portfolio deletion`
  String get portfolioListView_confirmDeleteDialogTitle {
    return Intl.message(
      'Portfolio deletion',
      name: 'portfolioListView_confirmDeleteDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete portfolio '{name}'?`
  String portfolioListView_confirmDeleteDialogContent(Object name) {
    return Intl.message(
      'Are you sure you want to delete portfolio \'$name\'?',
      name: 'portfolioListView_confirmDeleteDialogContent',
      desc: '',
      args: [name],
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

  /// `Edit`
  String get portfolioInstrumentListView_menuEdit {
    return Intl.message(
      'Edit',
      name: 'portfolioInstrumentListView_menuEdit',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get operationListViewItem_menuEdit {
    return Intl.message(
      'Edit',
      name: 'operationListViewItem_menuEdit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get operationListViewItem_menuDelete {
    return Intl.message(
      'Delete',
      name: 'operationListViewItem_menuDelete',
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