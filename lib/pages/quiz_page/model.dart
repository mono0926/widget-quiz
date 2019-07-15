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
  bool get quizListLoaded => _quizListLoaded;

  int _index = 0;
  bool get _hasQuiz => _index >= 0 && _index < (_quizList?.length ?? 0);
  Quiz get quiz => _hasQuiz ? _quizList[_index] : null;
  final _result = _Result();
  Stream<bool> get answered => _result.answered;
  ResultStatus get resultStatus => _result.value;

  void answer(WidgetData widget) {
    assert(
      _result.value == ResultStatus.notAnswered,
      'invalid result: ${_result.value}',
    );
    final correct = quiz.correct == widget;
    logger.info('correct: $correct');
    _result.value = correct ? ResultStatus.correct : ResultStatus.incorrect;
    notifyListeners();
  }

  void next() {
    _index++;
    if (!_hasQuiz) {
      logger.info('not more quiz');
      return;
    }
    _result.value = ResultStatus.notAnswered;
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
    _result.dispose();

    super.dispose();
  }
}

class _Result {
  var _value = ResultStatus.notAnswered;
  final _stream = StreamController<bool>();

  ResultStatus get value => _value;
  Stream<bool> get answered => _stream.stream;

  set value(ResultStatus result) {
    _value = result;
    if (result != ResultStatus.notAnswered) {
      _stream.add(result == ResultStatus.correct);
    }
  }

  void dispose() {
    _stream.close();
  }
}

enum ResultStatus {
  notAnswered,
  correct,
  incorrect,
}
