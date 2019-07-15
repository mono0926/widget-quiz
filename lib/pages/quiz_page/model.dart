import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:widget_quiz/model/model.dart';
import 'package:widget_quiz/util/util.dart';

enum AnswerResult {
  notAnswered,
  correct,
  incorrect,
}

class Model extends ChangeNotifier {
  Model({
    @required this.quizLoader,
  }) {
    _load();
  }

  final QuizLoader quizLoader;

  List<Quiz> _quizList;
  bool _quizListLoaded = false;
  bool get quizListLoaded => _quizListLoaded;

  int _index = 0;
  bool get _hasQuiz => _index >= 0 && _index < (_quizList?.length ?? 0);
  Quiz get quiz => _hasQuiz ? _quizList[_index] : null;
  final _answerResult =
      BehaviorSubject<AnswerResult>.seeded(AnswerResult.notAnswered);
  Stream<bool> get result => _answerResult
      .where((answer) => answer != AnswerResult.notAnswered)
      .map((answer) => answer == AnswerResult.correct);

  void answer(WidgetData widget) {
    assert(
      _answerResult.value == AnswerResult.notAnswered,
      'invalid result: ${_answerResult.value}',
    );
    final correct = quiz.correct == widget;
    logger.info('correct: $correct');
    _answerResult.value =
        correct ? AnswerResult.correct : AnswerResult.incorrect;
    notifyListeners();
  }

  void next() {
    _index++;
    if (!_hasQuiz) {
      logger.info('not more quiz');
      return;
    }
    _answerResult.value = AnswerResult.notAnswered;
    logger.info('changed to next quiz');
    notifyListeners();
  }

  void _load() async {
    // TODO(mono): くるくる出したいのでとりあえず
    await Future<void>.delayed(Duration(seconds: 1));
    _quizList = await quizLoader.load();
    _quizListLoaded = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _answerResult.close();

    super.dispose();
  }
}
