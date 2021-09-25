import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_securities/common/dialog_panel.dart';
import 'package:my_securities/common/utils.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/models/portfolio.dart';
import 'package:my_securities/widgets/appbar.dart';

class PortfolioEditDialog extends StatefulWidget {
  final Portfolio _portfolio;

  PortfolioEditDialog(this._portfolio, {Key key}) : super(key: key) {
    assert(_portfolio != null);
  }

  @override
  State<PortfolioEditDialog> createState() => _PortfolioEditDialogState(_portfolio);
}

class _PortfolioEditDialogState extends State<PortfolioEditDialog> {
  Portfolio _portfolio;
  final TextEditingController _nameEditController = TextEditingController();
  bool _visible;
  bool _hideSoldInstruments;

  _PortfolioEditDialogState (this._portfolio): super() {
    _nameEditController.text = _portfolio.name;
    _visible = _portfolio.visible;
    _hideSoldInstruments = _portfolio.hideSoldInstruments;
  }

  @override
  Widget build(BuildContext context) {

    bool _fabEnabled() {
      return _portfolio.name != null;
    }

    onFABPressed() async {
      widget._portfolio.update(name: _nameEditController.text, visible: _visible, hideSoldInstruments: _hideSoldInstruments);
      Navigator.pop(context, true);
    }

    return Scaffold(
      appBar: MySecuritiesAppBar(pageName: S.of(context).portfolioEditDialog_Title,),
      body: ChangeNotifierProvider<Portfolio>.value(
        value: widget._portfolio,
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
                            child: TextField(
                              controller: _nameEditController,
                              onChanged: (value) {_portfolio.name = value;},
                              decoration: InputDecoration(
                                icon: Icon(Icons.perm_identity),
                                labelText: S.of(context).portfolioEditDialog_Name,
                                contentPadding: EdgeInsets.all(3.0)
                              )),
                          ),
                        ]),
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _hideSoldInstruments,
                                      onChanged: (bool value) {
                                        setState(() {_hideSoldInstruments = value;});
                                      },
                                    ),
                                    Text(S.of(context).portfolioEditDialog_hideSoldInstruments)
                                  ]
                                )
                            )
                          )
                        ]
                      ),
                      Row(
                          children: [
                            Expanded(
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                        children: [
                                          Checkbox(
                                            value: _visible,
                                            onChanged: (bool value) {
                                              setState(() {_visible = value;});
                                            },
                                          ),
                                          Text(S.of(context).portfolioEditDialog_visible)
                                        ]
                                    )
                                )
                            )
                          ]
                      )
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
