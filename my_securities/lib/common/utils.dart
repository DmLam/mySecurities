import 'package:flutter/material.dart';

bool isKeyboardOpen(BuildContext context) => MediaQuery.of(context).viewInsets.bottom == 0.0;

String languageCode(BuildContext context) => Localizations.localeOf(context).languageCode;

// returns date part of the date
DateTime dateOf(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

// returns time part of the date
DateTime timeOf(DateTime date) {
  return DateTime(0, 0, 0, date.hour, date.minute, date.second, date.millisecond, date.microsecond);
}

// returns date part of the current date
DateTime currentDate() {
  return dateOf(DateTime.now());
}

// returns time part of the current date
DateTime currentTime() {
  return timeOf(DateTime.now());
}


