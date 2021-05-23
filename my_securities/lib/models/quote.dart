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
