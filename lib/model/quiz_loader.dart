import 'dart:convert';

import 'package:flutter/services.dart';

import 'entities/entities.dart';

class QuizLoader {
  Future<List<Quiz>> load() async {
    final widgets = (jsonDecode(
            await rootBundle.loadString('assets/data/widgets.json')) as List)
        .map<WidgetData>(
            (dynamic json) => WidgetData.fromJson(json as Map<String, dynamic>))
        .toList();
    return (widgets..shuffle())
        .sublist(0, 10)
        .map<Quiz>((correct) => Quiz(
              correct: correct,
              others: (widgets..shuffle())
                  .where((w) => w.name != correct.name)
                  .toList()
                  .sublist(0, 3),
            ))
        .toList();
  }
}
