class Quote {
  DateTime date;
  double open, low, high, close;

  Quote({required this.date, required this.open, required this.low, required this.high, required this.close});

  factory Quote.fromMap(Map<String, dynamic> json) =>
      Quote(date: DateTime.parse(json["date"]),
          open: json["open"],
          low: json["low"],
          high: json["high"],
          close: json["close"]
      );
}
