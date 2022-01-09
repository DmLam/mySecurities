import '../exchange.dart';

class Rate {
  Currency currency;
  DateTime date;
  double open, low, high, close;

  Rate({required this.currency, required this.date, required this.open, required this.low, required this.high, required this.close});

  factory Rate.fromMap(Map<String, dynamic> json) =>
      Rate(currency: Currency.values[json["currency_id"] - 1],
          date: DateTime.parse(json["date"]),
          open: json["open"],
          low: json["low"],
          high: json["high"],
          close: json["close"]
      );
}
