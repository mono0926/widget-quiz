import 'package:flutter_test/flutter_test.dart';
import 'package:widget_quiz/main.dart';

// TODO: 他にも書く。壊れているので直す。
void main() {
  test('CartItem test', () async {
    final widgets = await load();
    expect(widgets.length == 10, true);
  });
}
