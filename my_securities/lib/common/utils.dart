import 'package:flutter/material.dart';

bool isKeyboardOpen(BuildContext context) => MediaQuery.of(context).viewInsets.bottom == 0.0;

DateTime todayDate() {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

