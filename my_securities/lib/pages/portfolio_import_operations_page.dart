import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/models/portfolio.dart';
import 'package:my_securities/widgets/appbar.dart';
import 'package:file_picker/file_picker.dart';

class ImportPortfolioOperationsPage extends StatelessWidget {
  final Portfolio _portfolio;

  ImportPortfolioOperationsPage(this._portfolio, {Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {

    selectFile() async {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx']
      );
      Fluttertoast.showToast(msg: result.files.length.toString());
    }

    return Scaffold(
      appBar: MySecuritiesAppBar(pageName: S.of(context).importPortfolioOperationsPageTitle(_portfolio.name),),
      body: Center(
        child: ElevatedButton(
          child: Text(S.of(context).importPortfolioOperationsPageSelectFile),
          style: ElevatedButton.styleFrom(
            onSurface: Colors.blueAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: Colors.blueAccent)),
          ),
          onPressed: selectFile,
        )
      )
    );
  }

}