import 'package:flutter/material.dart';

Future<String> messageDialog(BuildContext context,
  {required String title, required String content,
    required List<String> actions, required String defaultResult}) async {
  String result = defaultResult;

  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: actions.map((title) =>
        TextButton(
          child: Text(title, textAlign: TextAlign.end),
          onPressed: () {
            result = title;
            Navigator.of(context).pop();
          },
        )
    ).toList()
  );

  await showDialog(
    context: context,
    builder: (BuildContext context) => alertDialog
  );

  return Future.value(result);
}