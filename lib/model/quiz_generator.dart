import 'dart:convert';

import 'package:http/http.dart';

import 'quiz.dart';
import 'w.dart';

// TODO: 安定のためにローカルに落とすべき？
Future<List<W>> fetch() async {
  final res = await Client().get(
      'https://api.github.com/repos/flutter/website/contents/src/_data/catalog/widgets.json'); // TODO:
  final content = (jsonDecode(String.fromCharCodes(base64Decode(
          (jsonDecode(res.body)['content'] as String)
              .replaceAll('\n', '')))) as List)
      .map((j) => W.fromJson(j as Map<String, dynamic>))
      .toList();
  return content;
}

Future<List<Quiz>> generate() async {
  final widgets = (await fetch())..shuffle();
  return widgets.map((correct) {
    return Quiz(
        correct: correct,
        others: widgets.where((w) => w != correct).toList().sublist(0, 3));
  }).toList();
}
