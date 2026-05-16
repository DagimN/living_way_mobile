import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/extensions/list.dart';

void main() {
  group('ListExtension.addOrReplace', () {
    test('adds item when finder does not match', () {
      final list = <int>[1, 2, 3];
      list.addOrReplace(4, (e) => e == 5);
      expect(list, [1, 2, 3, 4]);
    });

    test('replaces item when finder matches', () {
      final list = <String>['a', 'b', 'c'];
      list.addOrReplace('B', (e) => e == 'b');
      expect(list, ['a', 'B', 'c']);
    });

    test('replaces first matching item only', () {
      final list = [
        {'id': 1, 'value': 'old'},
        {'id': 2, 'value': 'keep'},
      ];
      list.addOrReplace({'id': 1, 'value': 'new'}, (e) => e['id'] == 1);
      expect(list[0]['value'], 'new');
      expect(list[1]['value'], 'keep');
    });
  });
}
