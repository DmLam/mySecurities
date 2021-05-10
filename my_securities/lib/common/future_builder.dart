import 'package:flutter/material.dart';

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

