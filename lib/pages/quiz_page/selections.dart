import 'package:flutter/material.dart';
import 'package:widget_quiz/model/model.dart';

import 'model.dart';

class Selections extends StatelessWidget {
  const Selections({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: model.quiz.candidates
          .map((widget) => _buildButton(
                context,
                widget: widget,
              ))
          .toList(),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    @required WidgetData widget,
  }) {
    final model = Provider.of<Model>(context);
    final currentAnswer = model.currentAnswer;
    final isCorrectAnswer = model.current == ProgressKind.correct;
    final answered = isCorrectAnswer || model.current == ProgressKind.incorrect;
    final isCorrectWidget = answered ? widget == model.quiz.correct : null;
    return RaisedButton(
      child: Text(widget.name),
      color: currentAnswer == null
          ? null
          : isCorrectWidget
              ? Colors.green
              : (currentAnswer == widget ? Colors.red : null),
      onPressed: () {
        model.answer(widget);
      },
    );
  }
}
