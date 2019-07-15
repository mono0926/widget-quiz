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
  final _history = _History();
  List<bool> get progress => _quizList
      .asMap()
      .map<int, bool>((index, quiz) => MapEntry<int, bool>(
            index,
            index >= 0 && index < _history.values.length
                ? _history.values[index]
                : null,
          ))
      .values
      .toList();
  Stream<bool> get answered => _history.answered;

  void answer(WidgetData widget) {
    final correct = quiz.correct == widget;
    logger.info('correct: $correct');
    _history.add(correct);
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
    await Future<void>.delayed(Duration(seconds: 1));
    _quizList = await quizLoader.load();
    _quizListLoaded = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _history.dispose();

    super.dispose();
  }
}

class _History {
  final _values = <bool>[];
  final _stream = StreamController<bool>();

  Stream<bool> get answered => _stream.stream;
  List<bool> get values => _values;

  // ignore: avoid_positional_boolean_parameters
  void add(bool result) {
    _values.add(result);
    _stream.add(result);
  }

  void dispose() {
    _stream.close();
  }
}
