import 'w.dart';

class Quiz {
  Quiz({
    this.correct,
    List<W> others,
  }) : candidates = others
          ..add(correct)
          ..shuffle();

  final W correct;
  final List<W> candidates;
}
