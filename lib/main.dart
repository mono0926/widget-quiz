import 'package:flutter/material.dart';
import 'package:widget_quiz/model/quiz.dart';

import 'model/quiz_generator.dart';
import 'quiz_page.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App();
  @override
  Widget build(BuildContext context) {
    const title = 'Widget Quiz!';
    return MaterialApp(
      title: title,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: FutureBuilder<List<Quiz>>(
          future: generate(),
          builder: (context, data) {
            if (!data.hasData) {
              return Center(child: const CircularProgressIndicator());
            }
            return SafeArea(
              child: QuizPage(quizzes: data.data),
            );
          },
        ),
      ),
    );
  }
}
