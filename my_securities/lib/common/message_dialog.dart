import 'package:flutter/material.dart';

Future<String> messageDialog(BuildContext context, String title, String content,
    List<String> actions) async {
  String result;

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