import 'dart:typed_data';
import '../generated/l10n.dart';
import '../common/exchange.dart';
import '../common/common.dart';

class Model {
  
}

class Quote {
  DateTime date;
  double open, low, high, close;

  Quote({this.date, this.open, this.low, this.high, this.close});

  factory Quote.fromMap(Map<String, dynamic> json) =>
            Quote(date: DateTime.parse(json["date"]),
              open: json["open"],
              low: json["low"],
              high: json["high"],
              close: json["close"]
            );
}

class Rate {
  Currency currency;
  DateTime date;
  double open, low, high, close;

  Rate({this.currency, this.date, this.open, this.low, this.high, this.close});

  factory Rate.fromMap(Map<String, dynamic> json) =>
      Rate(currency: Currency.values[json["currency_id"] - 1],
          date: DateTime.parse(json["date"]),
          open: json["open"],
          low: json["low"],
          high: json["high"],
          close: json["close"]
      );
}

class Money {
  Currency currency;
  double amount;

  Money({this.currency, this.amount});

  factory Money.fromMap(Map<String, dynamic> json) =>
      Money(currency: Currency.values[json["currency_id"] - 1],
        amount: json["amount"]
      );
}

class MoneyOperation {
  int id;
  Currency currency;
  DateTime date;
  MoneyOperationType type;
  double amount;

  MoneyOperation({this.id, this.currency, this.date, this.type, this.amount});

  factory MoneyOperation.fromMap(Map<String, dynamic> json) =>
      MoneyOperation(
        id: json["id"],
        currency: Currency.values[json["currency_id"] - 1],
        date: DateTime.parse(json["date"]),
        type: MoneyOperationType.values[json["type"] - 1],
        amount: json["amount"]
      );

  MoneyOperation.empty() {
    //DateTime now = DateTime.now();

    id = null;
    currency = null;
    date = null; //DateTime(now.year, now.month, now.day);
    type = null;
    amount = 0;
  }

  MoneyOperation.from(MoneyOperation op) :
    currency = op.currency,
    date = op.date,
    type = op.type,
    amount = op.amount;

  MoneyOperation assign(MoneyOperation op) {
    currency = op.currency;
    date = op.date;
    type = op.type;
    amount = op.amount;

    return op;
  }
}