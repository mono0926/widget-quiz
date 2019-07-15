import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_quiz/pages/quiz_page/quiz_page.dart';

import 'model/model.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: QuizLoader()),
      ],
      child: MaterialApp(
        home: QuizPage(),
      ),
    );
  }
}
