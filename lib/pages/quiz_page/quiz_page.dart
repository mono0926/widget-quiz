import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_quiz/model/model.dart';
import 'package:widget_quiz/pages/quiz_page/selections.dart';

import 'model.dart';
import 'progress.dart';
import 'question.dart';
import 'result_presenter.dart';

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => Model(
        quizLoader: Provider.of<QuizLoader>(context, listen: false),
      ),
      child: const _Page(),
    );
  }
}

class _Page extends StatefulWidget {
  const _Page({Key key}) : super(key: key);

  @override
  __PageState createState() => __PageState();
}

class __PageState extends State<_Page> {
  Model get _model => Provider.of<Model>(context, listen: false);
  final _resultPresenter = ResultPresenter();

  static const double _horizontalMargin = 16;

  @override
  void initState() {
    super.initState();

    _model.answered.listen((correct) async {
      await _resultPresenter.show(context, model: _model, correct: correct);
      _model.next();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Quiz'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final model = Provider.of<Model>(context);
    return SafeArea(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: model.quizListLoaded
            ? model.hasQuiz ? _buildQuiz() : _buildResult()
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildQuiz() {
    return Column(
      children: const [
        Progress(),
        Divider(
          indent: _horizontalMargin,
          endIndent: _horizontalMargin,
          height: 0,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(_horizontalMargin),
            physics: AlwaysScrollableScrollPhysics(),
            child: Question(),
          ),
        ),
        Padding(
          child: Selections(),
          padding: EdgeInsets.symmetric(horizontal: _horizontalMargin),
        ),
      ],
    );
  }

  Widget _buildResult() {
    final model = Provider.of<Model>(context);
//    model
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '⭕️ ${model.progress.where((p) => p == ProgressKind.correct).length} / 10',
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: model.progress
                .asMap()
                .map((index, p) => MapEntry(
                    index,
                    Text(
                        '${p == ProgressKind.correct ? '⭕️' : '❌'} ${model.quizList[index].correct.name}')))
                .values
                .toList(),
          ),
          const SizedBox(height: 8),
          RaisedButton(
            child: Text('TRY AGAIN'),
            onPressed: model.load,
          )
        ],
      ),
    );
  }
}
