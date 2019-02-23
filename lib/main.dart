import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

main() => runApp(A());

class A extends StatefulWidget {
  @override
  createState() => AS();
}

class AS extends State<A> {
  final nk = GlobalKey<NavigatorState>();
  List<Q> qs;
  Q get q => qs[i];
  int i = 0;
  final rs = <W, bool>{};

  @override
  initState() {
    super.initState();
    _reload();
  }

  _reload() async {
    final r = await load();
    setState(() {
      qs = r;
      i = 0;
      rs.clear();
    });
  }

  @override
  build(BuildContext c) {
    const t = 'Widget Quiz!';
    return MaterialApp(
      title: t,
      navigatorKey: nk,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: Scaffold(
        appBar: AppBar(
          title: Text(t),
        ),
        body: SafeArea(child: _bb()),
      ),
    );
  }

  Widget _bb() {
    if (qs == null) {
      return Center(child: CircularProgressIndicator());
    }
    if (i >= qs.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('⭕️: ${rs.values.where((r) => r).length} / 10'),
            RaisedButton(
              child: Text('TRY AGAIN'),
              onPressed: _reload,
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
              final key = q.correct;
              return Text(
                rs.containsKey(key)
                    ? (rs[key] ? '⭕️' : '❌')
                    : q == this.q ? '🔲' : '▫️',
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    q.correct.desc,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ]..addAll(q.candidates.map(_ba)),
          ),
        ),
      ],
    );
  }

  Widget _ba(W w) => RaisedButton(
        child: Text(w.name),
        onPressed: () => _hr(w == q.correct),
      );

  _hr(bool correct) async {
    {
      setState(() => rs[q.correct] = correct);
      await showDialog(
          context: nk.currentState.overlay.context,
          builder: (c) {
            return AlertDialog(
              title: correct ? Text('Correct ⭕️') : Text('Wrong ❌️'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MaterialButton(
                    minWidth: 0,
                    padding: EdgeInsets.zero,
                    child: Text(
                      '📄 ${q.correct.name}',
                      style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onPressed: () => launch(q.correct.link),
                  ),
                  SizedBox(height: 8),
                  Text(q.correct.desc),
                ],
              ),
              actions: [
                FlatButton(
                  child: Text('NEXT'),
                  onPressed: () => Navigator.of(c).pop(),
                )
              ],
            );
          });
      setState(() => i++);
    }
  }
}

class W {
  W({
    this.name,
    this.desc,
    this.link,
  });

  final String name;
  final String desc;
  final String link;

  W.fromJson(Map<String, dynamic> j)
      : name = j['name'],
        desc = j['description'],
        link = j['link'];
}

class Q {
  Q({
    this.correct,
    List<W> others,
  }) : candidates = others
          ..add(correct)
          ..shuffle();

  final W correct;
  final List<W> candidates;
}

Future<List<Q>> load() async {
  final ws = ((jsonDecode(await rootBundle.loadString('assets/w.json')) as List)
      .map((j) => W.fromJson(j as Map<String, dynamic>))
      .toList());
  return (ws..shuffle())
      .sublist(0, 10)
      .map((c) => Q(
          correct: c,
          others: (ws..shuffle())
              .where((w) => w.name != c.name)
              .toList()
              .sublist(0, 3)))
      .toList();
}
