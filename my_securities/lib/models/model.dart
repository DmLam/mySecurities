import 'package:my_securities/models/portfolio.dart';

class Model {
  static PortfolioList _portfolios;

  static PortfolioList portfolios() {
    if (_portfolios == null)
      _portfolios = PortfolioList();

    return _portfolios;
  }
}

