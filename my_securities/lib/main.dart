import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';
import 'common/common.dart';
import 'models/portfolio.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // needed to initialize ServicesBinding.defaultBinaryMessenger
  HttpProxy httpProxy = await HttpProxy.createHttpProxy();
  HttpOverrides.global = httpProxy;

  // initialize constants
  await S.load(Locale(Intl.getCurrentLocale()));  // init localization
  commonInit();

  runApp(MySecuritiesApp());
}

class MySecuritiesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          home: HomePage()
        )
      );
  }
}

