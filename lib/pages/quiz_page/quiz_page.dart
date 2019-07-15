import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_quiz/model/model.dart';
import 'package:widget_quiz/pages/quiz_page/selections.dart';

import 'model.dart';
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

  static const double _horizontalMargin = 16;

  @override
  __PageState createState() => __PageState();
}

class __PageState extends State<_Page> {
  Model get _model => Provider.of<Model>(context, listen: false);
  final _resultPresenter = ResultPresenter();

  @override
  void initState() {
    super.initState();

    _model.result.listen((correct) {
      _resultPresenter.show(context, model: _model, correct: correct);
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
        duration: Duration(milliseconds: 200),
        child: model.quizListLoaded
            ? _buildQuiz()
            : Center(child: const CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildQuiz() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: _Page._horizontalMargin),
            physics: const AlwaysScrollableScrollPhysics(),
            child: const Question(),
          ),
        ),
        const Padding(
          child: Selections(),
          padding: EdgeInsets.symmetric(horizontal: _Page._horizontalMargin),
        ),
      ],
    );
  }
}
