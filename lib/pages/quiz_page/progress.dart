import 'package:flutter/material.dart';
import 'package:widget_quiz/model/model.dart';

import 'model.dart';

class Progress extends StatelessWidget {
  const Progress({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context);
    return SizedBox(
      height: 44,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: model.progress.map((result) {
            return Text(result == null ? '▫' : result ? '⭕️️️' : '❌');
          }).toList(),
        ),
      ),
    );
  }
}
