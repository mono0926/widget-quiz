import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

main() => runApp(A());

const sz = SizedBox(height: 8);

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
    const t = 'Widget Quiz';
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
            Text(
              '⭕️ ${rs.values.where((r) => r).length} / 10',
              style: TextStyle(fontSize: 32),
            ),
            sz,
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
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: qs.map((q) {
                final key = q.c;
                return Text(
                  rs.containsKey(key)
                      ? (rs[key] ? '⭕️️️' : '❌')
                      : q == this.q ? '🔷' : '▫️',
                );
              }).toList(),
            ),
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
                    q.c.d,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ]..addAll(q.cs.map(_ba)),
          ),
        ),
      ],
    );
  }

  Widget _ba(W w) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: RaisedButton(
          child: Text(w.n),
          onPressed: () => _hr(w == q.c),
        ),
      );

  _hr(bool correct) async {
    {
      setState(() => rs[q.c] = correct);
      await showDialog(
          context: nk.currentState.overlay.context,
          builder: (c) {
            return AlertDialog(
              title: SizedBox(
                height: 60,
                child: FlareActor(
                  'assets/${correct ? 's' : 'f'}.flr',
                  animation: 's',
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    q.c.n,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  sz,
                  Text(q.c.d),
                ],
              ),
              actions: [
                FlatButton(
                  child: Text('DOCUMENTATION'),
                  onPressed: () => launch(q.c.l),
                ),
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
    this.n,
    this.d,
    this.l,
  });

  final String n;
  final String d;
  final String l;

  W.fromJson(Map j)
      : n = j['name'],
        d = j['description'],
        l = j['link'];
}

class Q {
  Q({
    this.c,
    List<W> others,
  }) : cs = others
          ..add(c)
          ..shuffle();

  final W c;
  final List<W> cs;
}

Future<List<Q>> load() async {
  final ws = ((jsonDecode(await rootBundle.loadString('assets/w.json')) as List)
      .map((j) => W.fromJson(j as Map))
      .toList());
  return (ws..shuffle())
      .sublist(0, 10)
      .map((c) => Q(
          c: c,
          others:
              (ws..shuffle()).where((w) => w.n != c.n).toList().sublist(0, 3)))
      .toList();
}
