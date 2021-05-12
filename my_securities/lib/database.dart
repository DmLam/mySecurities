import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:my_securities/models/model.dart';
import 'package:my_securities/models/portfolio.dart';
import 'package:my_securities/models/instrument.dart';
import 'package:my_securities/models/operation.dart';
import 'constants.dart';
import 'exchange.dart';
import 'models/money_operation.dart';


final int CURRENT_DB_VERSION = 1; // ignore: non_constant_identifier_names

String dbDateString(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  final int error_SQLITE_CONSTRAINT_UNIQUE = 2067; // ignore: non_constant_identifier_names
  final int error_SQLITE_CONSTRAINT_TRIGGER = 1811; // ignore: non_constant_identifier_names

  Future<Database> get database async {
    if (_database != null)
      return _database;

    await initDB();
    return _database;
  }

  int extractErrorCodeFromErrorMessage(String message) {
    int result = -1;
    RegExp re = RegExp(r"code (\d+)");

    RegExpMatch match = re.firstMatch(message);
    if (match != null) {
      result = int.parse(match[1]);
    }

    return result;
  }

  Future<void> _createTableCurrency(Database db) async {
    await db.execute('''CREATE TABLE currency (
                        id INTEGER PRIMARY KEY, 
                        name TEXT NOT NULL,
                        shortname TEXT NOT NULL,
                        sign TEXT);''');
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (1, 'Рубль', 'RUB', '₽')");
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (2, 'Доллар', 'USD', '\$')");
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (3, 'Евро', 'EUR', '€')");
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (4, 'Фунт', 'GBP', '£')");
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (5, 'Гонконгский доллар', 'HKD', 'HK\$')");
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (6, 'Швейцарский франк', 'CHF', '₣')");
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (7, 'Йена', 'JPY', '¥')");
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (8, 'Юань', 'CNY', '¥')");
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (9, 'Турецкая лира', 'TRY', '₺')");
  }
  Future<void> _createTableExchange(Database db) async {
    await db.execute('CREATE TABLE exchange (id INTEGER PRIMARY KEY, name TEXT NOT NULL, shortname TEXT NOT NULL, country TEXT NOT NULL)');
    for (Exchange ex in Exchange.values) {
      if (ex != Exchange.ASX)
        await db.insert('exchange', {'id': ex.index + 1, 'name': EXCHANGES[ex.name()]['name'], 'shortname': ex.name(), 'country': EXCHANGES[ex.name()]['country']});
    }
  }
  Future<void> _createTablePortfolio(Database db) async{
    await db.execute(
        '''CREATE TABLE portfolio (
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           name TEXT NOT NULL UNIQUE,
           visible BOOLEAN NOT NULL CHECK (visible IN (0, 1)) DEFAULT 1)''');
  }
  Future<void> _createTableInstrumentType(Database db) async {
    await db.execute('CREATE TABLE instrument_type (id INTEGER PRIMARY KEY, name TEXT NOT NULL);');
    await db.execute("INSERT INTO instrument_type (id, name) VALUES (1, '${INSTRUMENT_TYPE_NAMES[0]}')");
    await db.execute("INSERT INTO instrument_type (id, name) VALUES (2, '${INSTRUMENT_TYPE_NAMES[1]}')");
    await db.execute("INSERT INTO instrument_type (id, name) VALUES (3, '${INSTRUMENT_TYPE_NAMES[2]}')");
    await db.execute("INSERT INTO instrument_type (id, name) VALUES (4, '${INSTRUMENT_TYPE_NAMES[3]}')");
  }
  Future<void> _createTableInstrument(Database db) async {
    await db.execute(
      '''CREATE TABLE instrument (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          isin TEXT,
          ticker TEXT NOT NULL UNIQUE,
          name TEXT,
          currency_id INTEGER NOT NULL,
          instrument_type_id INTEGER NOT NULL,
          exchange_id INTEGER NOT NULL,
          additional TEXT,
          image BLOB,
          portfolio_percent_plan INTEGER,
          last_quote_update TEXT,
		      FOREIGN KEY (currency_id) REFERENCES currency(id) 
			      ON DELETE RESTRICT ON UPDATE RESTRICT,
		      FOREIGN KEY (instrument_type_id) REFERENCES instrument_type(id)
		        ON DELETE RESTRICT ON UPDATE RESTRICT,
		      FOREIGN KEY (exchange_id) REFERENCES exchange(id) 
		        ON DELETE RESTRICT ON UPDATE RESTRICT)''');
  }
  Future<void> _createTablePortfolioInstrument(Database db) async {
    await db.execute(
      '''CREATE TABLE portfolio_instrument(
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         portfolio_id INTEGER NOT NULL,
         instrument_id INTEGER NOT NULL,
         percent REAL,
         FOREIGN KEY (portfolio_id) REFERENCES portfolio(id) 
           ON DELETE CASCADE ON UPDATE RESTRICT,
         FOREIGN KEY (instrument_id) REFERENCES instrument(id) 
           ON DELETE RESTRICT ON UPDATE RESTRICT)''');
  }
  Future<void> _createTableMoney(Database db) async {
    await db.execute(
      '''CREATE TABLE money (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          portfolio_id INTEGER NOT NULL,
          currency_id INTEGER NOT NULL,
          date TEXT NOT NULL,
          type INTEGER NOT NULL,  
          amount REAL NOT NULL,
          operation_id INTEGER,
          FOREIGN KEY (portfolio_id) REFERENCES portfolio(id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,
          FOREIGN KEY (currency_id) REFERENCES currency(id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,
          FOREIGN KEY (operation_id) REFERENCES operation(id)
            ON DELETE RESTRICT ON UPDATE RESTRICT)''');
    await db.execute('CREATE INDEX idx_money_portfolio_id ON money (portfolio_id)');
    await db.execute('CREATE INDEX idx_money_currency_id ON money (currency_id)');
    await db.execute('CREATE INDEX idx_money_date ON money (date)');
    await db.execute('CREATE INDEX idx_operation_id ON money (operation_id)');
  }
  Future<void> _createTableOperation(Database db) async {
    await db.execute(
      '''CREATE TABLE operation (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          portfolio_instrument_id INTEGER NOT NULL,
          date TEXT NOT NULL,
          type INTEGER NOT NULL,
          quantity INTEGER NOT NULL,
          price REAL NOT NULL,
          value REAL NOT NULL,
          commission REAL DEFAULT 0,
          FOREIGN KEY (portfolio_instrument_id) REFERENCES portfolio_instrument(id)
            ON DELETE CASCADE ON UPDATE RESTRICT)''');
    await db.execute(
        'CREATE INDEX idx_operation_portfolio_instrument_id ON operation (portfolio_instrument_id)');
  }
  Future<void> _createTableQuote(Database db) async {
    // dates is stored in UNIX format
    await db.execute(
      '''CREATE TABLE quote (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date INTEGER NOT NULL,  
          instrument_id INTEGER NOT NULL,
          open double NOT NULL,
          close double NOT NULL,
          low double NOT NULL,
          high double NOT NULL,
          FOREIGN KEY (instrument_id) REFERENCES instrument(id)
            ON DELETE CASCADE ON UPDATE RESTRICT,
          UNIQUE (instrument_id, date))''');
    await db.execute(
        'CREATE INDEX idx_quote ON quote (instrument_id, date)');
  }
  Future<void> _createTableRate(Database db) async {
    // dates is stored in UNIX format
    await db.execute(
        '''CREATE TABLE rate (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date INTEGER NOT NULL,  
          currency_id INTEGER NOT NULL,
          rate double NOT NULL,
          FOREIGN KEY (currency_id) REFERENCES currency(id)
            ON DELETE CASCADE ON UPDATE RESTRICT,
          UNIQUE (currency_id, date))''');
    await db.execute(
        'CREATE INDEX idx_rate ON rate (currency_id, date)');
  }
  Future<void> _createTablePreference(Database db) async {
    await db.execute('''CREATE TABLE preference (
                        id INTEGER PRIMARY KEY,
                        main_currency_id INTEGER,
                        show_hidden_portfolios BOOLEAN NOT NULL CHECK (visible IN (0, 1)) DEFAULT 0), 
                        FOREIGN KEY (main_currency_id) REFERENCES currency(id)
                          ON DELETE RESTRICT ON UPDATE RESTRICT)''');
    await db.insert('preference', {'id': 1});
  }

  Future createTables(Database db) async {
    // справочник валют
    await _createTableCurrency(db);
    // справочник бирж
    await _createTableExchange(db);
    // портфели
    await _createTablePortfolio(db);
    // справочник типов инструментов
    await _createTableInstrumentType(db);
    // инструменты
    await _createTableInstrument(db);
    // инструменты по портфелям
    await _createTablePortfolioInstrument(db);
    // журнал операций
    await _createTableOperation(db);
    // котировки на дату
    await _createTableQuote(db);
    // курсы валют на дату (по отношению к рублю)
    await _createTableRate(db);
    // настройки
    await _createTablePreference(db);
    // ввод/вывод денег
    await _createTableMoney(db);
  }

  Future initTables(Database db) async {
    await db.insert("portfolio", {"name": S.current.defaultPortfolioName}, );
    await db.insert("instrument",
      {
        "isin": "bla-bla-bla",
        "ticker": "FXWO",
        "name": "Акции мирового рынка",
        "currency_id": 1,
        "instrument_type_id": 3,
        "exchange_id": 54
      });
    await db.insert("portfolio_instrument",
        {
          "portfolio_id": 1,
          "instrument_id": 1
        });
    await db.insert("operation",
      {
        "portfolio_instrument_id": 1,
        "date": dbDateString(DateTime(2021, 1, 12)),
        "type": 0,
        "quantity": 100,
        "price": 1.632,
        "value": 163.2
      });
  }

  void _onConfigure(Database db) async {
    // Add support for cascade delete
    await db.execute("PRAGMA foreign_keys = ON");
//    await db.execute('PRAGMA user_version = 1');
  }
  void _onCreate(Database db, int version) async {
    _database = db;

    await createTables(db);
    await initTables(db);
  }

  void _onOpen(Database db) async {
    _database = db;
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    _database = db;

  }

  void _onDowngrade(Database db, int oldVersion, int newVersion) async {
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "mysecurities.db");
    await deleteDatabase(path); // пока идет отладка
    await openDatabase(path,
      version: CURRENT_DB_VERSION,
      onConfigure: _onConfigure,
      onOpen: _onOpen,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: _onDowngrade
    );
  }

  _setPreference(final String preference, final dynamic value) async {
    final Database db = await database;
    await db.update('preference', {preference: value}, where: 'id = 1');
  }

  setPreferenceMainCurrency(final Currency mainCurrency) async {
    await _setPreference('main_currency_id', Currency.values.indexOf(mainCurrency) + 1);
  }

  Future<dynamic> _getPreference(final String preference) async {
    final Database db = await database;
    dynamic result;
    List<Map<String, dynamic>> q = await db.query('preference', columns: [preference], where: 'id = 1');

    result = q[0][preference];

    return Future.value(result);
  }

  Future<Currency> getPreferenceMainCurrency() async {
    int idx = await _getPreference('main_currency_id');
    Currency result;

    if (idx != null) {
      result = Currency.values[idx - 1];
    }

    return Future.value(result);
  }

  Future<int> addInstrument(Instrument instrument) async {
    final Database db = await database;
    await db.execute("INSERT INTO instrument (isin, ticker, name, currency_id, instrument_type_id, exchange_id, additional, portfolio_percent_plan) values (?, ?, ?, ?, ?, ?, ?, ?)",
        [instrument.isin, instrument.ticker, instrument.name, Currency.values.indexOf(instrument.currency) + 1,
         instrument.type.index + 1, instrument.exchange.index + 1, instrument.additional, instrument.portfolioPercentPlan]);
    var result = await db.rawQuery("SELECT MAX(id) as id FROM instrument");

    return result.first["id"];
  }

  Future<void> updateInstrument(Instrument instrument) async {
    final Database db = await database;
    Map<String, dynamic> row = {};

    row['ticker'] = instrument.ticker;
    row['name'] = instrument.name;
    row['currency_id'] = Currency.values.indexOf(instrument.currency) + 1;
    row['instrument_type_id'] = instrument.type.index + 1;
    row['exchange_id'] = instrument.exchange.index + 1;
    row['isin'] = instrument.isin;
    row['additional'] = instrument.additional;
    row['portfolio_percent_plan'] = instrument.portfolioPercentPlan;
    await db.update('instrument', row, where: 'id = ?', whereArgs: [instrument.id]);
  }

  setInstrumentImage(int instrumentId, Uint8List image) async {
    final Database db = await database;
    await db.execute('UPDATE instrument SET image = ? WHERE id = ?', [image, instrumentId]);
  }

  Future<int> getInstrumentCurrencyId(int instrumentId) async {
    int result;
    final Database db = await database;
    var currency = await db.rawQuery("SELECT currency_id FROM instrument WHERE id = ?", [instrumentId]);
    var r = currency.isNotEmpty ? currency.first['currency_id'] : null;
    if (r != null) {
      result = r;
    }
    return Future.value(result);
  }

  MoneyOperationType operationTypeToMoneyOperationType(OperationType op) {
    return op == OperationType.buy ? MoneyOperationType.buy : MoneyOperationType.sell;
  }

  Future<int> addOperation(Operation op, bool createMoneyOperation) async {
    final Database db = await database;
    final double operationValue = op.type == OperationType.buy ? op.quantity * op.price : -op.quantity * op.price;
    int currencyId = await getInstrumentCurrencyId(op.portfolioInstrumentId);
    final Batch batch = db.batch();
    batch.execute(
      "INSERT INTO operation (portfolio_instrument_id, date, type, quantity, price, value, commission) values (?, ?, ?, ?, ?, ?, ?)",
      [op.portfolioInstrumentId, dbDateString(op.date), op.type.index, op.quantity, op.price, operationValue, op.commission]);
    var operationId = await db.rawQuery("SELECT MAX(id) as id FROM operation");
    int result = operationId.first["id"];
    if (createMoneyOperation)
      batch.execute(
        "INSERT INTO money (currency_id, date, type, amount, operation_id) values (?, ?, ?, ?, ?)",
        [currencyId, dbDateString(op.date), operationTypeToMoneyOperationType(op.type).index + 1, operationValue - op.commission, result]);
    batch.commit(noResult: true);

    return Future.value(result);
  }

  updateOperation(Operation op) async {
    final Database db = await database;
    int currencyId = await getInstrumentCurrencyId(op.portfolioInstrumentId);
    final Batch batch = db.batch();

    batch.execute(
      "UPDATE operation SET date = ?, type = ?, quantity = ?, price = ?, value = ?, commission = ? WHERE id = ?",
      [dbDateString(op.date), op.type.index, op.quantity, op.price, op.value, op.commission, op.id]);
    batch.execute(
      "UPDATE money SET currency_id = ?,  date = ?, type = ?, amount = ? WHERE id = ?",
      [currencyId, dbDateString(op.date), operationTypeToMoneyOperationType(op.type).index + 1, op.value - op.commission]);
    batch.commit(noResult: true);
  }

  static final String _sqlInstrument =
      '''SELECT i.id, i.isin, i.ticker, i.name, i.currency_id, i.instrument_type_id, i.exchange_id, i.image, i.additional, i.portfolio_percent_plan, 
                i.additional, i.image, sum(o.quantity) quantity, sum(o.price * o.quantity) / sum(o.quantity) avgprice, sum(o.value) value, count(o.id) operation_count
         FROM instrument i LEFT JOIN operation o ON o.instrument_id = i.id , currency c 
         WHERE c.id = i.currency_id
           AND i.id = ?''';

  Future<Instrument> getInstrument(int id) async {
    final Database db = await database;
    var instrument = await db.rawQuery(_sqlInstrument, [id]);

    return instrument.isNotEmpty ? Instrument.fromMap(instrument.first) : null;
  }

  refreshInstrument(Instrument instrument) async {
    final Database db = await database;
    var inst = await db.rawQuery(_sqlInstrument, [instrument.id]);

    instrument.assign(inst.isNotEmpty ? Instrument.fromMap(inst.first) : Instrument.empty());
  }

  static final String _sqlPortfolioInstruments =
  '''SELECT i.id, i.isin, i.ticker, i.name, i.currency_id, i.instrument_type_id, i.exchange_id, i.additional, i.portfolio_percent_plan, 
                  i.additional, i.image, sum(o.quantity) quantity, sum(o.price * o.quantity) / sum(o.quantity) avgprice, sum(o.value) value, count(o.id) operation_count 
             FROM currency c, instrument i, portfolio_instrument pi LEFT OUTER JOIN operation o ON o.portfolio_instrument_id = pi.id 
            WHERE  
              c.id = i.currency_id AND
              pi.instrument_id = i.id
           GROUP BY i.id   
           HAVING i.id is not null''';

  Future<List<Instrument>> getPortfolioInstruments(int portfolioId) async {
    final Database db = await database;
    var instruments = await db.rawQuery(_sqlPortfolioInstruments);

    return instruments.isEmpty ? null:  instruments.map((i) => Instrument.fromMap(i)).toList();
  }


  deleteInstrument(int id) async {
    final Database db = await database;

    db.delete('instrument', where: 'id = ?', whereArgs: [id]);
    db.delete('quote', where: 'instrument_id = ?', whereArgs: [id]);
  }

  static final String _sqlPortfolioOperations =
  '''SELECT o.id, o.portfolio_instrument_id, po.instrument_id, o.date, o.type, o.quantity, o.price, o.value, o.commission
       FROM operation o, portfolio_instrument po
       WHERE o.portfolio_instrument_id = po.id
         and po.portfolio_id = ?  
    ''';

  Future<List<Operation>> getPortfolioOperations(int portfolioId) async {
    final Database db = await database;
    var operations = await db.rawQuery(_sqlPortfolioOperations, [portfolioId]);

    return operations.isNotEmpty ? operations.map((o) => Operation.fromMap(o)).toList() : null;
  }

  deleteOperation(int id) async {
    final Database db = await database;
    final Batch batch = db.batch();

    batch.delete('operation', where: 'id = ?', whereArgs: [id]);
    batch.delete('money', where: 'operation_id = ?', whereArgs: [id]);
    batch.commit(noResult: true);
  }

  addQuotes(int instrumentId, List<Quote> quotes) async {
    if (quotes.isNotEmpty) {
      final Database db = await database;
      final Batch batch = db.batch();

      for (var quote in quotes) {
        batch.insert('quote', {
          'instrument_id': instrumentId,
          'date': dbDateString(quote.date),
          'open': quote.open,
          'low': quote.low,
          'high': quote.high,
          'close': quote.close,
        });
      }
      batch.update('instrument', {'last_quote_update': dbDateString(DateTime.now())}, where: 'id = ?', whereArgs: [instrumentId]);
      batch.commit(noResult: true);
    }
  }

  addRates(List<Rate> rates) async {
    if (rates.isNotEmpty) {
      final Database db = await database;
      final Batch batch = db.batch();

      for (var rate in rates) {
        batch.insert('rate', {
          'currency_id': rate.currency.index + 1,
          'date': dbDateString(rate.date),
          'rate': rate.close,
        });
      }
      batch.commit(noResult: true);
    }
  }

  Future<DateTime> portfolioInstrumentFirstOperationDate(int portfolioInstrumentId) async {
    final Database db = await database;
    DateTime result;
    List<Map<String, dynamic>> r = await db.rawQuery('SELECT min(date) date FROM operation WHERE portfolio_instrument_id = ?', [portfolioInstrumentId]);

    if (r.isNotEmpty) {
      var date = r[0]['date'];
      if (date != null)
        result = DateTime.parse(date);
    }
    return Future.value(result);
  }

  Future<DateTime> instrumentLastQuoteUpdate(int instrumentId) async {
    final Database db = await database;
    DateTime result;
    List<Map<String, dynamic>> r = await db.query('instrument', columns: ['last_quote_update'], where: 'id = ?', whereArgs: [instrumentId]);

    if (r.isNotEmpty) {
      var date = r[0]['last_quote_update'];
      if (date != null)
        result = DateTime.parse(date);
    }

    return Future.value(result);
  }

  Future<DateTime> lastRateUpdate() async {
    final Database db = await database;
    DateTime result;
    List<Map<String, dynamic>> r = await db.rawQuery('SELECT max(date) date FROM rate');

    if (r.isNotEmpty) {
      var date = r[0]['date'];
      if (date != null)
        result = DateTime.parse(date);
    }
    return Future.value(result);
  }

  Future<DateTime> instrumentFirstQuoteDate(int instrumentId) async {
    final Database db = await database;
    DateTime result;
    List<Map<String, dynamic>> r = await db.rawQuery('SELECT min(date) date FROM quote WHERE instrument_id = ?', [instrumentId]);

    if (r.isNotEmpty) {
      var date = r[0]['date'];
      if (date != null)
        result = DateTime.parse(date);
    }
    return Future.value(result);
  }

  updateInstrumentLastQuoteDate(int instrumentId, DateTime updateDate) async {
    final Database db = await database;

    db.update('instrument', {'last_quote_update': dbDateString(updateDate)}, where: 'id = ?', whereArgs: [instrumentId]);
  }

  Future<Quote> instrumentLastQuote(int instrumentId) async {
    final Database db = await database;
    Quote result;

    List<Map<String, dynamic>> r = await db.rawQuery(
      '''SELECT date, open, low, high, close FROM quote 
         WHERE 
           instrument_id = ?
           AND date = (SELECT max(date) FROM quote WHERE instrument_id = ?)''', [instrumentId, instrumentId]);
    if (r.isNotEmpty) {
      result = Quote.fromMap(r[0]);
    }

    return Future.value(result);
  }

  Future<List<Money>> getMoneys() async {
    final Database db = await database;
    List<Money> result;

    List<Map<String, dynamic>> moneys = await db.rawQuery(
      'SELECT currency_id, sum(case WHEN type = 1 THEN amount ELSE -amount END) amount FROM money'
    );
    // если нет операций с деньгами, то будет возвращен набор данных из одной строки со всеми null в качестве значений
    if (moneys.isNotEmpty && moneys[0]['currency_id'] != null) {
      result = moneys.map((m) => Money.fromMap(m)).toList();
    }
    
    return Future.value(result);
  }

  Future<List<MoneyOperation>> getMoneyOperations() async {
    final Database db = await database;
    List<MoneyOperation> result;

    List<Map<String, dynamic>> operations = await db.rawQuery('SELECT * FROM money');
    if (operations.isNotEmpty) {
      result = operations.map((o) => MoneyOperation.fromMap(o)).toList();
    }

    return Future.value(result);
  }

  addMoneyOperation(MoneyOperation op) async {
    final Database db = await database;

    await db.insert('money', {'currency_id': op.currency.index + 1, 'date': dbDateString(op.date), 'type': op.type.index + 1, 'amount': op.amount});
  }

  updateMoneyOperation(MoneyOperation op) async {
    final Database db = await database;

    await db.update('money', {'id': op.id, 'currency_id': op.currency.index + 1, 'date': dbDateString(op.date), 'type': op.type.index + 1, 'amount': op.amount});
  }

  deleteMoneyOperation(int id) async {
    final Database db = await database;

    await db.delete('money',  where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Portfolio>> getPortfolios() async {
    final Database db = await database;
    List<Portfolio> result;

    List<Map<String, dynamic>> portfolios = await db.rawQuery(
        '''SELECT p.id, p.name, p.visible,
             (SELECT min(o.date) FROM operation o, portfolio_instrument pi WHERE o.portfolio_instrument_id = pi.id  AND pi.portfolio_id = p.id) start_date 
           FROM portfolio p'''
    );
    if (portfolios.isNotEmpty) {
      result = portfolios.map((p) => Portfolio.fromMap(p)).toList();
    }
    else
      result = [];

    return result;
  }

  Future<bool> addPortfolio(Portfolio portfolio) async {
    bool result = false;
    final Database db = await database;

    if (portfolio.id != null)
      Fluttertoast.showToast(msg: "Internal error: adding portfolio with id");
    else {
      try {
        await db.insert('portfolio', {'name': portfolio.name});
        result = true;
      }
      catch (e) {
        int code = extractErrorCodeFromErrorMessage(e.message);
        if (code == error_SQLITE_CONSTRAINT_UNIQUE) {
          Fluttertoast.showToast(
              msg: S.current.db_portfolioAlreadyExists(portfolio.name));
        }
      }
    }

    return Future.value(result);
  }

  Future<bool> updatePortfolio(Portfolio portfolio) async {
    bool result = false;
    final Database db = await database;

    if (portfolio.id == null)
      Fluttertoast.showToast(msg: "Internal error: updating portfolio without id");
    else {
      try {
        await db.update(
            'portfolio',
            {
              'name': portfolio.name,
              'visible': portfolio.visible ? 1 : 0,
            },
            where: 'id = ?',
            whereArgs: [portfolio.id]);
        result = true;
      }
      catch(e) {
        int code = extractErrorCodeFromErrorMessage(e.message);
        if (code == error_SQLITE_CONSTRAINT_UNIQUE) {
          Fluttertoast.showToast(msg: S.current.db_portfolioAlreadyExists(portfolio.name));
        }
      }
    }

    return Future.value(result);
  }

  Future<bool> deletePortfolio(Portfolio portfolio) async {
    bool result = false;
    final Database db = await database;

    if (portfolio.id == null)
      Fluttertoast.showToast(msg: "Internal error: deleting portfolio without id");
    else {
      try {
        await db.delete('portfolio', where: 'id = ?', whereArgs: [portfolio.id]);
        result = true;
      }
      catch(e) {
        int code = extractErrorCodeFromErrorMessage(e.message);
        if (code == error_SQLITE_CONSTRAINT_TRIGGER) {
          Fluttertoast.showToast(msg: S.current.db_portfolioNotEmpty);
        }
      }
    }

    return Future.value(result);
  }
}

