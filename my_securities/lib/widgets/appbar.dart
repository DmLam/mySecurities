import 'package:flutter/material.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/pages/settings_page.dart';

// идея взята https://stackoverflow.com/questions/53294006/how-to-create-a-custom-appbar-widget
class MySecuritiesAppBar extends StatefulWidget implements PreferredSizeWidget {
  String _pageName;
  bool _showSettingsMenu;
  MySecuritiesAppBar({Key key, String pageName, bool showSettingsMenu = true}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key) {
    _pageName = pageName;
    _showSettingsMenu = showSettingsMenu;
  }

  @override
  final Size preferredSize; // default is 56.0

  @override
  _MySecuritiesAppBarState createState() => _MySecuritiesAppBarState(_pageName, _showSettingsMenu);
}

class _MySecuritiesAppBarState extends State<MySecuritiesAppBar>{
  final String _pageName;
  final bool _showSettingsMenu;

  _MySecuritiesAppBarState(this._pageName, this._showSettingsMenu);

  // Реализовать скрытие пункта меню "Настройки" при showSettingsMenu = false

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(S.of(context).applicationTitle + (_pageName == null ? "" : " " + _pageName)),
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
              builder: (context) => SettingsPage()
          )
      );
  }
}