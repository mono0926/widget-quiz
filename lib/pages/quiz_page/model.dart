import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:widget_quiz/model/model.dart';
import 'package:widget_quiz/util/util.dart';

class Model extends ChangeNotifier {
  Model({
    @required this.quizLoader,
  }) {
    _load();
  }

  final QuizLoader quizLoader;

  List<Quiz> _quizList;
  bool _quizListLoaded = false;
  int _index = 0;
  final _answers = <WidgetData>[];
  final _answered = StreamController<bool>();

  bool get quizListLoaded => _quizListLoaded;
  bool get _hasQuiz => _index >= 0 && _index < (_quizList?.length ?? 0);
  Quiz get quiz => _hasQuiz ? _quizList[_index] : null;
  List<ProgressKind> get progress => _quizList
      .asMap()
      .map<int, ProgressKind>((index, quiz) => MapEntry<int, ProgressKind>(
            index,
            index >= 0 && index < _answers.length
                ? (_answers[index] == _quizList[index].correct
                    ? ProgressKind.correct
                    : ProgressKind.incorrect)
                : _index == index ? ProgressKind.current : ProgressKind.notYet,
          ))
      .values
      .toList();

  ProgressKind get current => progress[_index];
  WidgetData get currentAnswer =>
      current == ProgressKind.correct || current == ProgressKind.incorrect
          ? _answers[_index]
          : null;
  Stream<bool> get answered => _answered.stream;

  void answer(WidgetData widget) {
    final correct = quiz.correct == widget;
    logger.info('correct: $correct');
    _answers.add(widget);
    _answered.add(correct);
    notifyListeners();
  }

  void next() {
    _index++;
    if (!_hasQuiz) {
      logger.info('not more quiz');
      return;
    }
    logger.info('changed to next quiz');
    notifyListeners();
  }

  void _load() async {
    // TODO(mono): くるくる出したいのでとりあえず
    await Future<void>.delayed(const Duration(seconds: 1));
    _quizList = await quizLoader.load();
    _quizListLoaded = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _answered.close();

    super.dispose();
  }
}

enum ProgressKind {
  correct,
  incorrect,
  current,
  notYet,
}
