import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_securities/common/dialog_panel.dart';
import 'package:my_securities/common/utils.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/models/portfolio.dart';
import 'package:my_securities/widgets/appbar.dart';

class PortfolioEditDialog extends StatelessWidget {
  final Portfolio _portfolio;
  final TextEditingController _nameEditController = TextEditingController();

  PortfolioEditDialog(this._portfolio, {Key key}) : super(key: key) {
    assert(_portfolio != null);

    _nameEditController.text = _portfolio.name;
  }

  @override
  Widget build(BuildContext context) {

    bool _fabEnabled() {
      return _portfolio.name != null;
    }

    onFABPressed() async {
      bool result;

      if (_portfolio.id == null) {
        result = await context.read<PortfolioList>().add(_portfolio);
      }
      else {
        result = await _portfolio.update();
      }

      if (result)
        Navigator.pop(context, true);
    }

    return Scaffold(
      appBar: MySecuritiesAppBar(pageName: S.of(context).portfolioEditDialog_Title,),
      body: ChangeNotifierProvider<Portfolio>.value(
        value: _portfolio,
        child: SingleChildScrollView(
          child: Column(
            children: [
              dialogPanel(children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child:TextField(
                              controller: _nameEditController,
                              onChanged: (value) {_portfolio.name = value;},
                              decoration: InputDecoration(
                                icon: Icon(Icons.perm_identity),
                                labelText: S.of(context).portfolioEditDialog_Name,
                                contentPadding: EdgeInsets.all(3.0)
                              )),
                          ),
                        ]),
                    ],
                  ),
                ),
              ])
            ]
          )
        ),
      ),
      // don't show FAB if keyboard is opened, because the FAB overflows most bottom editor
      floatingActionButton:
      Visibility(
          visible: isKeyboardOpen(context), // check keyboard is open
          child: FloatingActionButton(
              child: Icon(Icons.done),
              // if not all data is entered ok then disable FAB: make it grey and null as 'onPressed'
              onPressed: _fabEnabled() ? onFABPressed : null,
              backgroundColor: _fabEnabled() ? Colors.lightBlueAccent : Colors.grey[100]
          )
      )
    );
  }
}
