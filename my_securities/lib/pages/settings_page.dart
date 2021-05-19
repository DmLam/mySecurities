import 'package:flutter/material.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/preferences.dart';
import 'package:my_securities/widgets/appbar.dart';
import 'package:pref/pref.dart';


class SettingsPage extends StatelessWidget {

  Widget body(BuildContext context) {

    return PrefPage(children: [
      PrefTitle(title: Text(S.of(context).prefTitleAppearance)),
      PrefCheckbox(
        title: Text(S.of(context).prefDarkTheme),
        pref: Preferences.prefDARK_THEME,
      ),
      PrefCheckbox(
          title: Text(S.of(context).prefShowHiddenPortfoliosTitle),
          pref: Preferences.prefSHOW_HIDDEN_PORTFOLIOS,
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