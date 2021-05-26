import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_securities/common/dialog_panel.dart';
import 'package:my_securities/common/utils.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/models/instrument.dart';
import 'package:my_securities/widgets/appbar.dart';
import 'package:provider/provider.dart';

class PortfolioInstrumentEditDialog extends StatelessWidget {
  final Instrument _instrument;
  final TextEditingController _percentEditController = TextEditingController();

  PortfolioInstrumentEditDialog(this._instrument, {Key key}) : super(key: key) {
    _percentEditController.text = _instrument.portfolioPercentPlan?.toString();
  }

  @override
  Widget build(BuildContext context) {

    bool _fabEnabled() => int.tryParse(_percentEditController.text) != null;

    onFabPressed() {
      _instrument.portfolioPercentPlan = int.parse(_percentEditController.text);

      Navigator.of(context).pop(true);
    }
    return Scaffold(
      appBar: MySecuritiesAppBar(pageName: S.of(context).portfolioInstrumentEditDialog_Title),
      body: ChangeNotifierProvider<Instrument>.value(
        value: _instrument,
        child: Column(
          children: [
            dialogPanel(children: [
              Expanded(child:
                Column(children: [
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: _percentEditController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.settings),
                            labelText: S.of(context).portfolioInstrumentEditDialog_percent(_instrument.portfolio.name),
                            contentPadding: EdgeInsets.all(3.0)
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      )
                  ])
                ])
              )
            ]),
          ])
      ),
      floatingActionButton: Visibility(
        visible: isKeyboardOpen(context), // check keyboard is open
        child: FloatingActionButton(
          child: Icon(Icons.done),
          // if not all data is entered ok then disable FAB: make it grey and null as 'onPressed'
          onPressed: _fabEnabled() ? onFabPressed : null,
          backgroundColor: _fabEnabled() ? Colors.lightBlueAccent : Colors.grey[100]
        )
      )
    );
  }
}
