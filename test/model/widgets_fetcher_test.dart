import 'package:flutter_test/flutter_test.dart';
import 'package:widget_quiz/model/quiz_generator.dart';

// TODO: 他にも書く
void main() {
  test('CartItem test', () async {
    final widgets = await load();
    expect(widgets.length >= 153, true);
  });
}
