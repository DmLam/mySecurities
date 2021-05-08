import 'package:flutter/material.dart';
import 'package:my_securities/generated/l10n.dart';

// идея взята https://stackoverflow.com/questions/53294006/how-to-create-a-custom-appbar-widget
class MySecuritiesAppBar extends StatefulWidget implements PreferredSizeWidget {
  String _pageName;
  MySecuritiesAppBar({Key key, String pageName}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key) {
    _pageName = pageName;
  }

  @override
  final Size preferredSize; // default is 56.0

  @override
  _MySecuritiesAppBarState createState() => _MySecuritiesAppBarState(_pageName);
}

class _MySecuritiesAppBarState extends State<MySecuritiesAppBar>{
  final String _pageName;

  _MySecuritiesAppBarState(this._pageName);

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
/*
  switch (value) {
    case 'Настройки':
            Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => SettingsPage()
          )
      );      break;
  }
 */
}