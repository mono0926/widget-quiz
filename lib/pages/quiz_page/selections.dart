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
    return RaisedButton(
      child: Text(widget.name),
      onPressed: () {
        model.answer(widget);
      },
    );
  }
}
