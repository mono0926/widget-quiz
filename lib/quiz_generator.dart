import 'dart:convert';

import 'package:flutter/services.dart';

import 'quiz.dart';
import 'w.dart';

Future<List<Quiz>> load() async {
  final ws =
      ((jsonDecode(await rootBundle.loadString('assets/widgets.json')) as List)
          .map((j) => W.fromJson(j as Map<String, dynamic>))
          .toList());
  return (ws..shuffle()).sublist(0, 10).map((c) {
    return Quiz(
        correct: c,
        others: (ws..shuffle())
            .where((w) => w.name != c.name)
            .toList()
            .sublist(0, 3));
  }).toList();
}
