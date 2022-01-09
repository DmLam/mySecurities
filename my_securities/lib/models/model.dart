import 'package:my_securities/models/portfolio.dart';

class Model {
  static PortfolioList? _portfolios;

  static PortfolioList get portfolios {
    PortfolioList result = _portfolios ?? PortfolioList();

    if (_portfolios == null) {
      _portfolios = result;
    }

    return result;
  }
}

