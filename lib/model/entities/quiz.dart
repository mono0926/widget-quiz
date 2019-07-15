import 'package:meta/meta.dart';

import 'entities.dart';

class Quiz {
  Quiz({
    @required this.correct,
    @required List<WidgetData> others,
  }) : candidates = others
          ..add(correct)
          ..shuffle();

  final WidgetData correct;
  final List<WidgetData> candidates;
}
