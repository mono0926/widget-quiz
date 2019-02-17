import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widget_quiz/model/quiz.dart';

import 'model/w.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({@required this.quizzes});
  final List<Quiz> quizzes;

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  Quiz quiz;

  @override
  void initState() {
    super.initState();
    quiz = widget.quizzes.removeLast();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quizzes.isEmpty) {
      return Container(); // TODO:
    }
    return _QuizView(
      quiz: quiz,
      onTap: (correct) async {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: correct ? Text('Correct👍') : Text('Wrong☹️'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      quiz.correct.name,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                    SizedBox(height: 8),
                    Text(quiz.correct.description),
                  ],
                ),
                actions: [
                  FlatButton(
                    child: Text('VIEW DOCUMENT'),
                    onPressed: () {
                      launch(quiz.correct.link);
                    },
                  ),
                  FlatButton(
                    child: Text('NEXT'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
        setState(() {
          quiz = widget.quizzes.removeLast();
        });
      },
    );
  }
}

class _QuizView extends StatelessWidget {
  const _QuizView({@required this.quiz, this.onTap});

  final Quiz quiz;
  final Function(bool correct) onTap;

  @override
  Widget build(BuildContext context) {
    final candidates = quiz.candidates;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 32,
          color: Theme.of(context).primaryColor,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(
              quiz.correct.description,
              style: Theme.of(context).textTheme.title,
            ),
            physics: const AlwaysScrollableScrollPhysics(),
          ),
        ),
      ]..addAll(candidates.map(_buildAnswer)),
    );
  }

  Widget _buildAnswer(W w) {
    return RaisedButton(
      child: Text(w.name),
      onPressed: () {
        onTap(w == quiz.correct);
      },
    );
  }
}
