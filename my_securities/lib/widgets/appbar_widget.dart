import 'package:flutter/material.dart';

// идея взята https://stackoverflow.com/questions/53294006/how-to-create-a-custom-appbar-widget
class MySecuritiesAppBar extends StatefulWidget implements PreferredSizeWidget {
  MySecuritiesAppBar({Key key}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _MySecuritiesAppBarState createState() => _MySecuritiesAppBarState();
}

class _MySecuritiesAppBarState extends State<MySecuritiesAppBar>{

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("My securities"),
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return {'Настройки'}.map((String choice) {
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