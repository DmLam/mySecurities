import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:my_securities/common/classes.dart';
import 'package:my_securities/common/common.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/models/portfolio.dart';
import 'package:my_securities/widgets/appbar.dart';

class PortfolioEditDialog extends StatefulWidget {
  final Portfolio _portfolio;

  PortfolioEditDialog(this._portfolio, {Key key}) : super(key: key) {
    if (_portfolio.id == null)
      _portfolio.startDate = DateTime.now();
  }

  @override
  _PortfolioEditDialogState createState() => _PortfolioEditDialogState();
}

class _PortfolioEditDialogState extends State<PortfolioEditDialog> {
  final TextEditingController _nameEditController = TextEditingController();
  final TextEditingController _startDateEditController = TextEditingController();

  _PortfolioEditDialogState() {
    _nameEditController.text = widget._portfolio?.name;
    _startDateEditController.text = DateFormat.yMd(ui.window.locale.languageCode).format(widget._portfolio.startDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MySecuritiesAppBar(),
      body: SingleChildScrollView(
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
                          child: TextField(
                            textAlign: TextAlign.end,
                            controller: _startDateEditController,
                            readOnly: true,
                            decoration: InputDecoration(
                                icon: Icon(Icons.event),
                                labelText: S.of(context).portfolioEditDialog_startDate,
                                contentPadding: EDIT_UNDERLINE_PADDING
                            ),
                            onTap: () {
                              showDatePicker(
                                  context: context,
                                  initialDate: widget._portfolio.startDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now()).then((date) =>
                              {
                                if (date != null) {
                                  setState(() {
                                    widget._portfolio.startDate = date;
                                    _startDateEditController.text = DateFormat.yMd(ui.window.locale.languageCode).format(date);
                                  })
                                }
                              });
                            }
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ])
          ]
        )
      )
    );
  }
}
