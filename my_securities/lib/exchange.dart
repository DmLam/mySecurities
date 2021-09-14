// Listing Exchange Codes
// https://propreports.atlassian.net/wiki/spaces/PR/pages/589983/Listing+Exchange+Codes
enum Exchange {
  ASX, VIE, SAO, BMF, BRU, BUL, CSE, TOR, VAN, SGO, HKG, SHA, SHE, BVC, ZSE,
  CYP, PRG, CPH, TAL, HEL, PAR, BER, GER, FRA, STU, ATH, BDP, NSE, BSE, JKT,
  DUB, TLV, MIL, FUK, NJM, JSD, NAG, TSE, OSE, RSE, VSE, LUX, MAC, KLS, MEX,
  LBC, AMS, NZE, OSL, KSA, PHS, WAR, LIS, MCX, SES, LJE, JSE, SAF, KFE, KSC,
  KDQ, BCN, MCE, MFM, COL, STO, NGM, BRN, VTX, EBS, TAI, BKK, IST, IOB, LSE,
  BTS, IEX, NAS, ASE, PCX, NYQ, OPR, OBB, PNK, HSX}

Map<String, Map<String, String>> EXCHANGES = { // ignore: non_constant_identifier_names
  'ASX': {'country': 'Australia', 'name': 'Australian Stock Exchange'},
  'VIE': {'country': 'Austria', 'name': 'Vienna Stock Exchange'},
  'SAO': {'country': 'Brazil', 'name': 'BOVESPA - Sao Paolo Stock Exchange'},
  'BMF': {'country': 'Brazil', 'name': 'Brazil Mercantile & Futures Exchange'},
  'BRU': {'country': 'Belgium', 'name': 'Euronext Brussels'},
  'BUL': {'country': 'Bulgaria', 'name': 'Bulgarian Stock Exchange'},
  'CSE': {'country': 'Canada', 'name': 'Canadian Stock Exchange'},
  'TOR': {'country': 'Canada', 'name': 'Toronto Stock Exchange'},
  'VAN': {'country': 'Canada', 'name': 'Toronto Venture Exchange'},
  'SGO': {'country': 'Chile', 'name': 'Santiago Stock Exchange'},
  'HKG': {'country': 'China', 'name': 'Hong Kong Stock Exchange'},
  'SHA': {'country': 'China', 'name': 'Shanghai Stock Exchange'},
  'SHE': {'country': 'China', 'name': 'Shenzhen Stock Exchange'},
  'BVC': {'country': 'Colombia', 'name': 'Columbia Stock Exchange (Bolsa de Valores de Columbia)'},
  'ZSE': {'country': 'Croatia', 'name': 'Zagreb Stock Exchange'},
  'CYP': {'country': 'Cyprus', 'name': 'Cyprus Stock Exchange'},
  'PRG': {'country': 'Czech Republic', 'name': 'Prague Stock Exchange'},
  'CPH': {'country': 'Denmark', 'name': 'Copenhagen Stock Exchange'},
  'TAL': {'country': 'Estonia', 'name': 'OMX Baltic Exchange - Talinn'},
  'HEL': {'country': 'Finland', 'name': 'Helsinki Stock Exchange'},
  'PAR': {'country': 'France', 'name': 'Euronext Paris'},
  'BER': {'country': 'Germany', 'name': 'Berlin Stock Exchange'},
  'GER': {'country': 'Germany', 'name': 'XETRA Stock Exchange'},
  'FRA': {'country': 'Germany', 'name': 'Frankfurt Stock Exchange'},
  'STU': {'country': 'Germany', 'name': 'Stuttgart Stock Exchange'},
  'ATH': {'country': 'Greece', 'name': 'Athens Stock Exchange'},
  'BDP': {'country': 'Hungary', 'name': 'Budapest Stock Exchange'},
  'NSE': {'country': 'India', 'name': 'National Stock Exchange of India'},
  'BSE': {'country': 'India', 'name': 'Bombay Stock Exchange'},
  'JKT': {'country': 'Indonesia', 'name': 'Jakarta Stock Exchange'},
  'DUB': {'country': 'Ireland', 'name': 'Irish Stock Exchange'},
  'TLV': {'country': 'Israel', 'name': 'Tel Aviv Stock Exchange'},
  'MIL': {'country': 'Italy', 'name': 'Milan Stock Exchange / Borsa Italia'},
  'FUK': {'country': 'Japan', 'name': 'Fukuoka Stock Exchange'},
  'NJM': {'country': 'Japan', 'name': 'Hercules Stock Exchange'},
  'JSD': {'country': 'Japan', 'name': 'JASDAQ Securities Exchange'},
  'NAG': {'country': 'Japan', 'name': 'Nagoya Stock Exchange'},
  'TSE': {'country': 'Japan', 'name': 'Tokyo Stock Exchange'},
  'OSE': {'country': 'Japan', 'name': 'Osaka Securities Exchange'},
  'RSE': {'country': 'Latvia', 'name': 'OMX Baltic'},
  'VSE': {'country': 'Lithuania', 'name': 'OMX Baltic Exchange - Vilnius'},
  'LUX': {'country': 'Luxembourg', 'name': 'Luxembourg Stock Exchange'},
  'MAC': {'country': 'Macedonia', 'name': 'Macedonian Stock Exchange'},
  'KLS': {'country': 'Malaysia', 'name': 'Malaysia Exchange'},
  'MEX': {'country': 'Mexico', 'name': 'Mexico Stock Exchange'},
  'LBC': {'country': 'Morocco', 'name': 'Casablanca Stock Exchange (Bourse de Casablanca)'},
  'AMS': {'country': 'Netherlands', 'name': 'Amsterdam Exchange'},
  'NZE': {'country': 'New Zealand', 'name': 'New Zealand Stock Exchange'},
  'OSL': {'country': 'Norway', 'name': 'Oslo Bors'},
  'KSA': {'country': 'Pakistan', 'name': 'Karachi'},
  'PHS': {'country': 'Philippines', 'name': 'Philippine Stock Exchange'},
  'WAR': {'country': 'Poland', 'name': 'Warsaw Stock Exchange'},
  'LIS': {'country': 'Portugal', 'name': 'Euronext Lisbon'},
  'MCX': {'country': 'Russia', 'name': 'Moscow Exchange (MOEX)'},
  'SES': {'country': 'Singapore', 'name': 'Singapore Exchange'},
  'LJE': {'country': 'Slovenia', 'name': 'Ljubljana Stock Exchange'},
  'JSE': {'country': 'South Africa', 'name': 'Johannesburg Stock Exchange'},
  'SAF': {'country': 'South Africa', 'name': 'South African Futures Exchange'},
  'KFE': {'country': 'South Korea', 'name': 'Korean Futures Exchange (KOFEX)'},
  'KSC': {'country': 'South Korea', 'name': 'Korea Stock Exchange'},
  'KDQ': {'country': 'South Korea', 'name': 'KOSDAQ'},
  'BCN': {'country': 'Spain', 'name': 'Barcelona Stock Exchange'},
  'MCE': {'country': 'Spain', 'name': 'Madrid Stock Exchange (Cats)'},
  'MFM': {'country': 'Spain', 'name': 'Mercado Español de Futuros Financieros (MEFF)'},
  'COL': {'country': 'Sri Lanka', 'name': 'Colombo Stock Exchange'},
  'STO': {'country': 'Sweden', 'name': 'Stockholm Stock Exchange'},
  'NGM': {'country': 'Sweden', 'name': 'Nordic Growth Market'},
  'BRN': {'country': 'Switzerland', 'name': 'Berne eXchange'},
  'VTX': {'country': 'Switzerland', 'name': 'SIX Swiss Exchange'},
  'EBS': {'country': 'Switzerland', 'name': 'Swiss Electronic Bourse'},
  'TAI': {'country': 'Taiwan', 'name': 'Taiwan Stock Exchange'},
  'BKK': {'country': 'Thailand', 'name': 'Thailand Stock Exchange'},
  'IST': {'country': 'Turkey', 'name': 'Istanbul Stock Exchange'},
  'IOB': {'country': 'United Kingdom', 'name': 'International Order Book'},
  'LSE': {'country': 'United Kingdom', 'name': 'London Stock Exchange'},
  'BTS': {'country': 'United States', 'name': 'BATS Global Markets'},
  'IEX': {'country': 'United States', 'name': '"Investor''s Exchange, LLC"'},
  'NAS': {'country': 'United States', 'name': 'NASDAQ'},
  'ASE': {'country': 'United States', 'name': 'NYSE Market (Amex)'},
  'PCX': {'country': 'United States', 'name': 'NYSE Arca'},
  'NYQ': {'country': 'United States', 'name': 'NYSE'},
  'OPR': {'country': 'United States', 'name': 'OPRA'},
  'OBB': {'country': 'United States', 'name': 'OTC Bulletin Board Market'},
  'PNK': {'country': 'United States', 'name': 'Pink Sheets'},
  'HSX': {'country': 'Vietnam', 'name': 'HoChiMinh Stock Exchange'},
};

final List CurrencyNames = Currency.values.map((currency) => currency.name).toList(); // ignore: non_constant_identifier_names

extension ExchangeExtenstion on Exchange {
  String name() {
    return this.toString().split('.').last;
  }
}

Exchange exchangeFromName(String name) {
  return Exchange.values.firstWhere((Exchange element) => element.name() == name);
}

enum Currency {RUB, USD, EUR, GBP, HKD, CHF, JPY, CNY, TRY}
List CurrencySigns = ['₽', '\$', '€', '£', 'HK\$', '₣', '¥', '¥', '₺']; // ignore: non_constant_identifier_names

extension CurrencyExtension on Currency {
  int get id => index + 1;

  String get name => this.toString().split('.').last;

  String get sign => CurrencySigns[Currency.values.indexOf(this)];

  static Currency byId(int id) => Currency.values[id - 1];
}

// Unfortunately, static extension's method doesn't work like Currency.byId(1), only using extension name instead on type name
// like CurrencyExtension.byId(1),
// see https://stackoverflow.com/questions/59725226/is-there-a-way-to-add-a-static-extension-method-on-a-class-directly-in-dart
// so, I simply wrote function currencyById(int id)
Currency currencyById(int id) => Currency.values[id - 1];

const CURRENCY_ROUND_ACCURACY = 4;

String formatCurrency(double d, {Currency currency}) {
  String s;

  if (d != null) {
    s = d.toStringAsFixed(CURRENCY_ROUND_ACCURACY);
    while (s.length > 1 && s.substring(s.length - 1) == '0') {
      s = s.substring(0, s.length - 1);
    }
    if (s.length > 1 && s.substring(s.length - 1) == '.') {
      s += '0';
    }

    if (currency != null) {
      s += ' ' + CurrencySigns[currency.index];
    }
  }
  return s;
}

void exchangeInit() {
  // dummy function to init variables in the module
}