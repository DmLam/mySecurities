import 'package:flutter/material.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/pages/settings_page.dart';

// идея взята https://stackoverflow.com/questions/53294006/how-to-create-a-custom-appbar-widget
class MySecuritiesAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String pageName;
  final bool showSettingsMenu;
  MySecuritiesAppBar({Key key, this.pageName, this.showSettingsMenu = true}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _MySecuritiesAppBarState createState() => _MySecuritiesAppBarState(pageName, showSettingsMenu);
}

class _MySecuritiesAppBarState extends State<MySecuritiesAppBar>{
  final String _pageName;
  final bool _showSettingsMenu;

  _MySecuritiesAppBarState(this._pageName, this._showSettingsMenu);

  // Реализовать скрытие пункта меню "Настройки" при showSettingsMenu = false

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_pageName == null ? S.of(context).applicationTitle : _pageName),
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return {S.of(context).appBar_settings}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
          onSelected: (value) {handleMenuSelection(context, value);},
        )
      ],
    );
  }
}

void handleMenuSelection(BuildContext context, String value) {
  if (value == S.of(context).appBar_settings) {
            Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SettingsPage(),
            fullscreenDialog: true
          )
      );
  }
}