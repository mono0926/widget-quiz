import 'package:flutter/material.dart';
import 'package:widget_quiz/model/model.dart';

import 'model.dart';

class Question extends StatelessWidget {
  const Question({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context);
    final quiz = model.quiz;
    if (quiz == null) {
      return const SizedBox();
    }
    return Text(
      quiz.correct.description,
      style: Theme.of(context).textTheme.headline,
    );
  }
}
