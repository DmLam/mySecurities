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
      child: MySecuritiesApp()
    )
  );
}

class MySecuritiesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(
        providers: [
          ChangeNotifierProvider<Preferences>(create: (_) => Preferences()),
          ChangeNotifierProvider<PortfolioList>(create: (_) => PortfolioList())
        ],
        child: MaterialApp(
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          title: "My securities",
          home: HomePage()
        )
    );
  }
}
