import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:my_securities/common/future_builder.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/models/instrument.dart';
import 'package:my_securities/models/portfolio.dart';
import 'package:my_securities/pages/portfolio_instrument_edit_dialog.dart';
import 'package:my_securities/pages/portfolio_operation_page.dart';
import 'package:provider/provider.dart';
import '../exchange.dart';
import '../quote_provider.dart';


class PortfolioInstrumentsListView extends StatelessWidget {
  final InstrumentList _instruments;

  PortfolioInstrumentsListView(this._instruments, {Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _instruments.instruments.length,
      itemBuilder: (BuildContext context, int index) =>
        ChangeNotifierProvider<Instrument>.value(value: _instruments.instruments[index],
          child: PortfolioInstrumentListItem(_instruments.portfolio, _instruments.instruments[index]))
    );
  }
}

class PortfolioInstrumentListItem extends StatelessWidget {
  final Portfolio _portfolio;
  final Instrument _instrument;

  PortfolioInstrumentListItem(this._portfolio, this._instrument, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uint8List imageBytes = context.watch<Instrument>().image;
    Widget image = imageBytes == null ? Icon(Icons.attach_money) :
                   Image.memory(imageBytes, width: 30, height: 30);
    Future<double> priceFuture =
      QuoteProvider.of(_instrument).getCurrentPrice();

    void editPortfolioInstrument() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PortfolioInstrumentEditDialog(_instrument),
          fullscreenDialog: true
        )
      );
    }

    void showPortfolioOperations() {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PortfolioOperationPage(_portfolio, instrument: context.read<Instrument>(),)));
    }

    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(2.0, 0.0, 8.0, 0.0),
      leading: Container(
          width: 36,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _instrument.ticker,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.teal, fontSize: 12),
                ),
                image,
              ]
          )
      ),
      title: Row(children: [
        Expanded(
            flex: 70,
            child: Text(_instrument.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
        Expanded(
            flex: 30,
            child: Column(children: [
              Text(_instrument.valueString(),
                  style: TextStyle(fontSize: 12), textAlign: TextAlign.right),
              futureBuilder<double>(
                  future: priceFuture,
                  resultWidget: (price) {
                    double profit = 0;
                    String sprofit = '';
                    if (price != null) {
                      profit = _instrument.profit(price);
                      sprofit = _instrument.profitString(price);
                    }
                    return Text(
                        (profit > 0 ? '+' : profit < 0 ? '-' : '') + sprofit,
                        style: TextStyle(
                            fontSize: 12,
                            color: profit > 0 ? Colors.green : Colors.red),
                        textAlign: TextAlign.right);
                  },
                  waitWidget: Text(''))
            ])
        ) // Column
      ]),
      subtitle: Row(mainAxisSize: MainAxisSize.max, children: [
        Text(
            (_instrument.quantity ?? 0) * (_instrument.averagePrice ?? 0) == 0
                ? ''
                : _instrument.quantityString() +
                ' * ' +
                _instrument.averagePriceString(),
            style: TextStyle(fontSize: 12)),
        Text('  '),
        futureBuilder<double>(
            future: priceFuture,
            resultWidget: (price) {
              return Row(children: [
                Text(formatCurrency(price) ?? "",
                    style: TextStyle(fontSize: 12, color: Colors.yellow),
                    textAlign: TextAlign.right)
              ]);
            },
            waitWidget: Text(''))
      ]),
      trailing: Container(
          width: 20,
          child: PopupMenuButton(
              itemBuilder: (_) => <PopupMenuItem<String>>[
                PopupMenuItem<String>(
                    value: "edit",
                    child: Text(S.of(context).portfolioInstrumentListView_menuEdit)),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    editPortfolioInstrument();
                    break;
                  // case 'delete':
                  //   DBProvider.db.deleteInstrument(_instrument.id);
                  //   break;
                  default:
                    throw Exception("Unknown instrument menu item");
                }
              })),
      onTap: showPortfolioOperations,
    );
  }
}

