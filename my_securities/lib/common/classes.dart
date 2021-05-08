import 'package:flutter/material.dart';

const EdgeInsets PANEL_PADDING = EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0);
const EdgeInsets PANEL_MARGIN = EdgeInsets.all(6.0);

Widget dialogPanel({List<Widget> children, EdgeInsets margin = PANEL_MARGIN, EdgeInsets padding = PANEL_PADDING}) {
  return
    Container(
        margin: margin,
        padding: padding,
//        color: Colors.grey[600],
        child:
        Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: children
        )
    );
}

Widget futureBuilder<T>({Future<T> future, Widget resultWidget(T), Widget errorWidget, Widget waitWidget}) {
  return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return errorWidget ?? Center(child: Text(snapshot.error.toString(),
            style: TextStyle(color: Colors.redAccent, fontSize: 14),));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitWidget ?? Container(width: 30,
              height: 30,
              alignment: Alignment.center,
              child: CircularProgressIndicator());
        }
        else
          return resultWidget(snapshot.data);
      }
  );
}
