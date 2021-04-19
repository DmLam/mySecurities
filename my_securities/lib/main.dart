import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:intl/intl.dart';
import 'generated/l10n.dart';
import 'common/common.dart';
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
    return MaterialApp(
      title: "My securities",
      home: HomePage()
    );
  }
}

