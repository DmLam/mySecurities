import 'package:flutter/material.dart';
import 'package:my_securities/common/types.dart';
import 'package:my_securities/common/utils.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/pages/settings_page.dart';

// идея взята https://stackoverflow.com/questions/53294006/how-to-create-a-custom-appbar-widget
class MySecuritiesAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? pageName;
  final List<String>? menuItems;
  final List<VoidCallback>? menuHandlers;
  final bool showSettingsMenu;

  MySecuritiesAppBar({Key? key, this.menuItems, this.menuHandlers, this.pageName, this.showSettingsMenu = true}) :
        preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key)
  {
    assert(menuItems?.length == menuHandlers?.length, "Count of menu items should be equal to count of menu handlers");
  }

  @override
  final Size preferredSize; // default is 56.0

  @override
  _MySecuritiesAppBarState createState() => _MySecuritiesAppBarState(pageName, menuItems, menuHandlers, showSettingsMenu);
}

class _MySecuritiesAppBarState extends State<MySecuritiesAppBar>{
  final String? _pageName;
  final List<String>? menuItems;
  final List<VoidCallback>? menuHandlers;
  final bool showSettingsMenu;

  _MySecuritiesAppBarState(this._pageName, this.menuItems, this.menuHandlers, this.showSettingsMenu);

  List<PopupMenuItem> popupMenuItemBuilder(BuildContext context) {
    final List<String>? menuItems = this.menuItems;
    List<PopupMenuItem> result = [];

    if (menuItems != null)
      result = menuItems.map((String item) =>
          PopupMenuItem<String>(
              value: item,
              child: Text(item),
          )).toList();

    if (showSettingsMenu)
      result.add(
        PopupMenuItem<String>(
          value: S.of(context).appBar_settings,
          child: Text(S.of(context).appBar_settings),
        )
      );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final String? pageName = this._pageName;
    final String title = pageName == null ? S.of(context).applicationTitle : pageName;

    return AppBar(
      title: Text(title,
          style: TextStyle(fontStyle: _pageName == null ? FontStyle.normal : FontStyle.italic)),
      actions: [
        PopupMenuButton(
          itemBuilder: popupMenuItemBuilder,
          onSelected: (value) {handleMenuSelection(context, value.toString());}
        )
      ],
    );
  }

  showSettingsPage(BuildContext context) {
    MaterialPageRoute mpr = MaterialPageRoute(
        builder: (context) => SettingsPage(),
        fullscreenDialog: true
    );
    Navigator.of(context).push(mpr);
  }

  void handleMenuSelection(BuildContext context, String value) {
    final List<String>? menuItems = this.menuItems;
    final List<VoidCallback>? menuHandlers = this.menuHandlers;

    if (value == S.of(context).appBar_settings) {
      showSettingsPage(context);
    }
    else {
      if (menuItems != null && menuHandlers != null)
        menuHandlers[menuItems.indexOf(value)]();
    }
  }
}
