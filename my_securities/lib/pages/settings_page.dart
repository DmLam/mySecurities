import 'package:flutter/material.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/preferences.dart';
import 'package:my_securities/widgets/appbar.dart';
import 'package:pref/pref.dart';

import '../exchange.dart';


class SettingsPage extends StatelessWidget {

  Widget body(BuildContext context) {

    return PrefPage(children: [
      PrefTitle(title: Text(S.of(context).prefTitleMain)),
      PrefDropdown<int>(
          title: Text(S.of(context).prefMainCurrencyTitle),
          fullWidth: false,
          pref: Preferences.prefMAIN_CURRENCY_ID,
          items: Currency.values.map((currency) => DropdownMenuItem(value: currency.index, child: Text(currency.name))).toList()),
      PrefTitle(title: Text(S.of(context).prefTitleAppearance)),
      PrefCheckbox(
        pref: Preferences.prefDARK_THEME,
        title: Text(S.of(context).prefDarkTheme),
      ),
      PrefCheckbox(
        pref: Preferences.prefSHOW_HIDDEN_PORTFOLIOS,
        title: Text(S.of(context).prefShowHiddenPortfoliosTitle),
      ),
      PrefCheckbox(
        pref: Preferences.prefHIDE_SOLD_INSTRUMENTS,
        title: Text(S.of(context).prefHideSoldInstruments)
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MySecuritiesAppBar(pageName: 'Settings',),
      body: body(context)
    );
  }
}