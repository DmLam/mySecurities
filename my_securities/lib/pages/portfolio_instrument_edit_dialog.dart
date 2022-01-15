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
  final TextEditingController _commissionEditController = TextEditingController();

  PortfolioInstrumentEditDialog(this._instrument, {Key? key}) : super(key: key) {
    _percentEditController.text = _instrument.portfolioPercentPlan?.toString() ?? "";
    _commissionEditController.text = _instrument.commission?.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {

    bool _fabEnabled() => int.tryParse(_percentEditController.text) != null ||
      double.tryParse(_commissionEditController.text) != null;

    onFabPressed() {
      _instrument.update(
        portfolioPercentPlan: int.tryParse(_percentEditController.text),
        commission: double.tryParse(_commissionEditController.text)
      );

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
                  ]),
                  Row(
                      children: [
                        Expanded(
                            child: TextField(
                              controller: _commissionEditController,
                              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))
                              ],
                              decoration: InputDecoration(
                                icon: Icon(Icons.monetization_on),
                                labelText: S.of(context).portfolioEditDialog_Commission,
                                contentPadding: EdgeInsets.all(3.0),
                                suffix: Text('%', style: TextStyle(fontSize: 22)),
                              ),
                            )
                        ),
                      ]),

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
