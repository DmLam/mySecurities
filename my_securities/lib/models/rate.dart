import '../exchange.dart';

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
