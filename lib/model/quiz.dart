import 'package:meta/meta.dart';

import 'w.dart';

class Quiz {
  Quiz({
    @required this.correct,
    @required List<W> others,
  })  : assert(others.length == 3),
        candidates = others
          ..add(correct)
          ..shuffle();

  final W correct;
  final List<W> candidates;
}
