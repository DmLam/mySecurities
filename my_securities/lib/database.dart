import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:my_securities/models/portfolio.dart';
import 'package:my_securities/models/instrument.dart';
import 'package:my_securities/models/operation.dart';
import 'constants.dart';
import 'exchange.dart';
import 'models/money.dart';
import 'models/money_operation.dart';
import 'models/quote.dart';
import 'models/rate.dart';


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
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (${Currency.RUB.id}, 'Рубль', 'RUB', '₽')");
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (${Currency.USD.id}, 'Доллар', 'USD', '\$')");
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (${Currency.EUR.id}, 'Евро', 'EUR', '€')");
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (${Currency.GBP.id}, 'Фунт', 'GBP', '£')");
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (${Currency.HKD.id}, 'Гонконгский доллар', 'HKD', 'HK\$')");
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (${Currency.CHF.id}, 'Швейцарский франк', 'CHF', '₣')");
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (${Currency.JPY.id}, 'Йена', 'JPY', '¥')");
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (${Currency.CNY.id}, 'Юань', 'CNY', '¥')");
    await db.execute("INSERT INTO currency (id, name, shortname, sign) values (${Currency.TRY.id}, 'Турецкая лира', 'TRY', '₺')");
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
         percent INTEGER,
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
    // ввод/вывод денег
    await _createTableMoney(db);
  }

  Future initTables(Database db) async {
    await db.insert("portfolio", {"name": S.current.defaultPortfolioName}, );
/*
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
*/
  }

  void _onConfigure(Database db) async {
    // Add support for cascade delete
    await db.execute("PRAGMA foreign_keys = ON");
  }
  void _onCreate(Database db, int version) async {
    _database = db;

    await db.execute('PRAGMA user_version = 1');
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
//    await deleteDatabase(path); // пока идет отладка
    await openDatabase(path,
      version: CURRENT_DB_VERSION,
      onConfigure: _onConfigure,
      onOpen: _onOpen,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: _onDowngrade
    );
  }

  Future<int> addInstrument(String ticker, String isin, String name, Currency currency, InstrumentType type, Exchange exchange, String additional) async {
    final Database db = await database;
    await db.execute("INSERT INTO instrument (isin, ticker, name, currency_id, instrument_type_id, exchange_id, additional) values (?, ?, ?, ?, ?, ?, ?)",
        [isin, ticker, name, Currency.values.indexOf(currency) + 1,
         type.index + 1, exchange.index + 1, additional]);
    var result = await db.rawQuery("SELECT MAX(id) as id FROM instrument");

    return result.first["id"];
  }

  Future<bool> updateInstrument(Instrument instrument) async {
    bool result = false;

    if (instrument.id == null)
      Fluttertoast.showToast(msg: "Internal error: updating instrument without id");
    else {
      final Database db = await database;
      db.transaction((txn) async {
        Map<String, dynamic> row = {};


        row['ticker'] = instrument.ticker;
        row['name'] = instrument.name;
        row['currency_id'] = Currency.values.indexOf(instrument.currency) + 1;
        row['instrument_type_id'] = instrument.type.index + 1;
        row['exchange_id'] = instrument.exchange.index + 1;
        row['isin'] = instrument.isin;
        row['additional'] = instrument.additional;
        txn.update(
            'instrument', row, where: 'id = ?', whereArgs: [instrument.id]);
        txn.update('portfolio_instrument',
            {"percent": instrument.portfolioPercentPlan},
            where: 'portfolio_id = ? and instrument_id = ?',
            whereArgs: [instrument.portfolio.id, instrument.id]);

        result = true;
      });
    }

    return Future.value(result);
  }

  setInstrumentImage(int instrumentId, Uint8List image) async {
    final Database db = await database;
    await db.execute('UPDATE instrument SET image = ? WHERE id = ?', [image, instrumentId]);
  }

  Future<int> getInstrumentId(String isin) async {
    int result;
    final Database db = await database;
    var instrument = await db.rawQuery("SELECT id FROM instrument WHERE isin = ?", [isin]);
    var r = instrument.isNotEmpty ? instrument.first['id'] : null;
    if (r != null)
      result = r;

    return Future.value(result);
  }

  static final String _sqlInstruments =
  '''SELECT i.id, i.isin, i.ticker, i.name, i.currency_id, i.instrument_type_id, i.exchange_id, i.additional, i.portfolio_percent_plan, 
                  i.additional, i.image, sum(o.quantity) quantity, sum(o.price * o.quantity) / sum(o.quantity) avgprice, sum(o.value) value, count(o.id) operation_count 
             FROM currency c, instrument i  
            WHERE  
              c.id = i.currency_id AND
              pi.instrument_id = i.id
           GROUP BY i.id   
           HAVING i.id is not null''';

  Future<List<Instrument>> getInstruments() async {
    final Database db = await database;
    var instruments = await db.rawQuery(_sqlInstruments);

    return instruments.isEmpty ? null:  instruments.map((i) => Instrument.fromMap(i)).toList();
  }

  static final String _sqlPortfolioInstruments =
  '''SELECT i.id, pi.portfolio_id, i.isin, i.ticker, i.name, i.currency_id, i.instrument_type_id, i.exchange_id, i.additional, pi.percent, 
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

    return instruments.isNotEmpty ? instruments.map((i) => Instrument.fromMap(i)).toList() : <Instrument>[];
  }

   deleteInstrument(int id) async {
     final Database db = await database;

     await db.transaction((txn) async {
       txn.delete('instrument', where: 'id = ?', whereArgs: [id]);
       txn.delete('quote', where: 'instrument_id = ?', whereArgs: [id]);
     });
   }

  Future<int> _getPortfolioInstrumentId(int portfolioId, int instrumentId) async {
    final Database db = await database;
    var pi = await db.query('portfolio_instrument', columns: ['id'], where: 'portfolio_id=? and instrument_id=?', whereArgs: [portfolioId, instrumentId] );

    return Future.value(pi.isEmpty ? null : pi[0]['id']);
  }

  static final String _sqlPortfolioOperations =
  '''SELECT o.id, pi.portfolio_id, pi.instrument_id, o.date, o.type, o.quantity, o.price, o.value, o.commission, 
            m.id money_operation_id
     FROM operation o LEFT JOIN money m ON m.operation_id = o.id, portfolio_instrument pi
     WHERE o.portfolio_instrument_id = pi.id
       and pi.portfolio_id = ?
    ''';
  static final String _sqlPortfolioInstrumentOperations =
  '''SELECT o.id, pi.portfolio_id, pi.instrument_id, o.date, o.type, o.quantity, o.price, o.value, o.commission,
            m.id money_operation_id
     FROM operation o LEFT JOIN money m ON m.operation_id = o.id, portfolio_instrument pi
     WHERE o.portfolio_instrument_id = pi.id
       and pi.portfolio_id = ?
       and pi.instrument_id = ?
    ''';

  Future<List<Operation>> getPortfolioOperations(int portfolioId, {int instrumentId}) async {
    final Database db = await database;
    List<Map<String, dynamic>> operations =
      instrumentId == null ?
        await db.rawQuery(_sqlPortfolioOperations, [portfolioId]) :
        await db.rawQuery(_sqlPortfolioInstrumentOperations, [portfolioId, instrumentId]);

    return operations.isNotEmpty ? operations.map((o) => Operation.fromMap(o)).toList() : <Operation>[];
  }

  Future<int> addOperation(Operation op, {MoneyOperation moneyOperation}) async {
    assert(op.id == null);
    assert(op.instrument != null);

    final Database db = await database;
    int portfolioInstrumentId = await _getPortfolioInstrumentId(op.portfolio.id, op.instrument.id);

    await db.transaction((txn) async {
      // if there is no this instrument in this portfolio, then create relation
      if (portfolioInstrumentId == null)
        portfolioInstrumentId = await txn.insert('portfolio_instrument',
            {'portfolio_id': op.portfolio.id,
              'instrument_id': op.instrument.id});

      op.id = await txn.insert('operation',
          {'portfolio_instrument_id': portfolioInstrumentId,
            'date': dbDateString(op.date),
            'type': op.type.index,
            'quantity': op.quantity,
            'price': op.price,
            'value': op.value,
            'commission': op.commission});

      if (moneyOperation != null)
        addMoneyOperation(moneyOperation, dbe: txn);
    });

    return Future.value(op.id);
  }

  updateOperation(Operation op) async {
    final Database db = await database;

    await db.transaction((txn) async {
      txn.update('operation',
          {'date': dbDateString(op.date),
            'type': op.type.index,
            'quantity': op.quantity,
            'price': op.price,
            'value': op.value,
            'comission': op.commission},
          where: 'id = ?',
          whereArgs: [op.id]);

      txn.update('money',
          {'currency_id': op.instrument.currency.id,
            'date': dbDateString(op.date),
            'type': operationTypeToMoneyOperationType(op.type).id,
            'amount': op.value - op.commission},
          where: 'operation_id = ?',
          whereArgs: [op.id]);
    });
  }

  deleteOperation(Operation op) async {
    final Database db = await database;
    int portfolioInstrumentId = await _getPortfolioInstrumentId(op.portfolio.id, op.instrument.id);

    await db.transaction((txn) async {
      await txn.delete('money', where: 'operation_id = ?', whereArgs: [op.id]);
      await txn.delete('operation', where: 'id = ?', whereArgs: [op.id]);

      var restOpCount = await txn.rawQuery('SELECT count(*) cnt FROM operation where portfolio_instrument_id = ?', [portfolioInstrumentId]);
      if (restOpCount[0]['cnt'] == 0)
        await txn.delete('portfolio_instrument',
            where: 'portfolio_id = ? and instrument_id = ?',
            whereArgs: [op.portfolio.id, op.instrument.id]
        );
    });
  }

  addQuotes(int instrumentId, List<Quote> quotes) async {
    if (quotes.isNotEmpty) {
      final Database db = await database;

      await db.transaction((txn) async {
        for (var quote in quotes) {
          txn.insert('quote', {
            'instrument_id': instrumentId,
            'date': dbDateString(quote.date),
            'open': quote.open,
            'low': quote.low,
            'high': quote.high,
            'close': quote.close,
          });
        }
        txn.update('instrument', {'last_quote_update': dbDateString(DateTime.now())}, where: 'id = ?', whereArgs: [instrumentId]);
      });
    }
  }

  addRates(List<Rate> rates) async {
    if (rates.isNotEmpty) {
      final Database db = await database;
      db.transaction((txn) async {
        for (var rate in rates) {
          txn.insert('rate', {
            'currency_id': rate.currency.index + 1,
            'date': dbDateString(rate.date),
            'rate': rate.close,
          });
        }
      });
    }
  }

  static final String sqlInstrumentFirstOperationDate = ''
      '''SELECT min(o.date) date 
         FROM operation o, portfolio_instrument pi 
         WHERE o.portfolio_instrument_id = pi.id and po.instrument_id = ?
      ''';

  Future<DateTime> instrumentFirstOperationDate(int instrumentId) async {
    final Database db = await database;
    DateTime result;
    List<Map<String, dynamic>> r = await db.rawQuery(sqlInstrumentFirstOperationDate, [instrumentId]);

    if (r.isNotEmpty) {
      var date = r[0]['date'];
      if (date != null)
        result = DateTime.parse(date);
    }
    return Future.value(result);
  }
  Future<DateTime> portfolioInstrumentFirstOperationDate(int portfolioId, int instrumentId) async {
    final Database db = await database;
    DateTime result;
    int portfolioInstrumentId = await _getPortfolioInstrumentId(portfolioId, instrumentId);
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

  static final _sqlPortfolioMonies =
  '''SELECT m.portfolio_id, m.currency_id, sum(case WHEN m.type = 1 THEN m.amount ELSE -m.amount END) amount 
     FROM money m
     WHERE m.portfolio_id = ?
     GROUP BY m.currency_id
     HAVING sum(case WHEN m.type = 1 THEN m.amount ELSE -m.amount END) <> 0
  ''';

  Future<List<Money>> getPortfolioMonies(int portfolioId) async {
    final Database db = await database;
    List<Map<String, dynamic>> money =
    await db.rawQuery(_sqlPortfolioMonies, [portfolioId]);

    return money.isNotEmpty ? money.map((m) => Money.fromMap(m)).toList() : <Money>[];
  }

  static final _sqlPortfolioMoneyOperations =
    'SELECT id, portfolio_id, operation_id, currency_id, date, type, amount FROM money WHERE portfolio_id = ? ORDER BY date, id';

  Future<List<MoneyOperation>> getPortfolioMoneyOperations(int portfolioId) async {
    final Database db = await database;
    List<MoneyOperation> result;

    List<Map<String, dynamic>> operations = await db.rawQuery(_sqlPortfolioMoneyOperations, [portfolioId]);
    if (operations.isNotEmpty) {
      result = operations.map((o) => MoneyOperation.fromMap(o)).toList();
    }

    return Future.value(result);
  }

  addMoneyOperation(MoneyOperation mop, {DatabaseExecutor dbe}) async {
    final Database db = dbe ?? await database;

    await db.insert( 'money',
        {
          'portfolio_id': mop.portfolio.id,
          'currency_id': mop.currency.id,
          'date': dbDateString(mop.date),
          'type': mop.type.id,
          'amount': mop.amount,
          'operation_id': mop.operation?.id
        });
  }

  updateMoneyOperation(MoneyOperation mop) async {
    final Database db = await database;

    await db.update('money',
        {
          'id': mop.id,
          'currency_id': mop.currency.id,
          'date': dbDateString(mop.date),
          'type': mop.type.id,
          'amount': mop.amount
        });
  }

  deleteMoneyOperation(MoneyOperation mop) async {
    final Database db = await database;

    await db.delete('money',  where: 'id = ?', whereArgs: [mop.id]);
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

  Future<int> addPortfolio(Portfolio portfolio) async {
    assert(portfolio.id == null, 'Internal error: adding portfolio with id');

    int result;
    final Database db = await database;

    try {
      result = await db.insert('portfolio', {'name': portfolio.name});
    }
    catch (e) {
      int code = extractErrorCodeFromErrorMessage(e.message);
      if (code == error_SQLITE_CONSTRAINT_UNIQUE) {
        Fluttertoast.showToast(
            msg: S.current.db_portfolioAlreadyExists(portfolio.name));
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

