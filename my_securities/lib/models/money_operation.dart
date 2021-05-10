import '../exchange.dart';

enum MoneyOperationType {deposit, withdraw, buy, sell}  // buy and sell is only for non-money operations (i.e. buying and selling securities)

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