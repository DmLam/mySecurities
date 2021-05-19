import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:intl/intl.dart';
import 'package:my_securities/preferences.dart';
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'generated/l10n.dart';
import 'exchange.dart';
import 'models/portfolio.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // needed to initialize ServicesBinding.defaultBinaryMessenger
  HttpProxy httpProxy = await HttpProxy.createHttpProxy();
  HttpOverrides.global = httpProxy;

  Preferences preferences = Preferences();
  await preferences.ready;

  // initialize constants
  await S.load(Locale(Intl.getCurrentLocale()));  // init localization
  exchangeInit();
  constantsInit();

  runApp(
    PrefService(
      service: preferences.service,
      child: MySecuritiesApp(preferences)
    )
  );
}

class MySecuritiesApp extends StatelessWidget {
  final Preferences _preferences;

  MySecuritiesApp(this._preferences);

  @override
  Widget build(BuildContext context) {
    return
      ChangeNotifierProvider<Preferences>.value(
        value: _preferences,
        builder: (context, widget) {
          return
            ChangeNotifierProvider<PortfolioList>(
                    create: (_) => PortfolioList(),
              child: MaterialApp(
                  localizationsDelegates: [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  title: "My securities",
                  theme: context
                      .watch<Preferences>()
                      .darkTheme ? ThemeData.dark() : ThemeData.light(),
                  home: HomePage()
              )
          );
        });
  }
}

