import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widget_quiz/model/quiz.dart';
import 'package:widget_quiz/model/w.dart';

import 'model/quiz_generator.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  final nkey = GlobalKey<NavigatorState>();
  int i = 0;
  List<Quiz> qs;
  final rs = <String, bool>{};
  Quiz get q => qs[i];

  @override
  Widget build(BuildContext c) {
    const title = 'Widget Quiz!';
    return MaterialApp(
      title: title,
      navigatorKey: nkey,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: FutureBuilder<List<Quiz>>(
          future: generate(),
          builder: (c, s) {
            if (!s.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            qs = s.data;
            return SafeArea(
              child: _buildPage(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage() {
    if (i >= qs.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('⭕️: ${rs.values.where((r) => r).length} / 10'),
            RaisedButton(
              child: Text('TRY AGAIN'),
              onPressed: () {
                setState(() {
                  i = 0;
                  rs.clear();
                });
              },
            )
          ],
        ),
      );
    }
    return Column(
      children: [
        SizedBox(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: qs.map((q) {
              final key = q.correct.name;
              if (rs.containsKey(key)) {
                return Text(rs[q.correct.name] ? '⭕️' : '❌');
              }
              return Text('▫️');
            }).toList(),
          ),
        ),
        Expanded(
          child: _QuizView(
            q,
            onTap: _handleResult,
          ),
        ),
      ],
    );
  }

  void _handleResult(bool correct) async {
    {
      final ctx = nkey.currentState.overlay.context;
      rs[q.correct.name] = correct;
      await showDialog(
          context: ctx,
          builder: (c) {
            return AlertDialog(
              title: correct ? Text('Correct 👍') : Text('Wrong ☹️'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MaterialButton(
                    minWidth: 0,
                    child: Text(
                      '📄 ${q.correct.name}',
                      style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onPressed: () => launch(q.correct.link),
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox(height: 8),
                  Text(q.correct.desc),
                ],
              ),
              actions: [
                FlatButton(
                  child: Text('NEXT'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            );
          });
      setState(() {
        i++;
      });
    }
  }
}

class _QuizView extends StatelessWidget {
  _QuizView(this.q, {this.onTap});

  final Quiz q;
  final Function(bool correct) onTap;

  @override
  Widget build(BuildContext c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              q.correct.desc,
              style: Theme.of(c).textTheme.title,
            ),
          ),
        ),
      ]..addAll(q.candidates.map(_buildAnswer)),
    );
  }

  Widget _buildAnswer(W w) {
    return RaisedButton(
      child: Text(w.name),
      onPressed: () {
        onTap(w == q.correct);
      },
    );
  }
}
