import 'package:flutter_test/flutter_test.dart';
import 'package:widget_quiz/model/quiz_generator.dart';

void main() {
  test('CartItem test', () async {
    final widgets = await fetch();
    expect(widgets.length, 153);
  });
}
