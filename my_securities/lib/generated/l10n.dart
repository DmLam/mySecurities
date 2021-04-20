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