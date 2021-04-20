import 'package:flutter/material.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/widgets/portfolio_list_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.applicationTitle),
      ),
      body: PortfolioList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.question_answer)
      ),
    );
  }
}
