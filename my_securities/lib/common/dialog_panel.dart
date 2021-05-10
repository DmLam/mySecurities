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

