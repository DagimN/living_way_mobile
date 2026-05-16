import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/extensions/datetime.dart';

void main() {
  group('DateTimeExtension.dateInNumbers', () {
    test('formats year without 20 prefix plus month day hour', () {
      final date = DateTime(2025, 5, 16, 14);
      expect(date.dateInNumbers, 2551614);
    });

    test('handles different hours', () {
      final morning = DateTime(2024, 1, 1, 8);
      expect(morning.dateInNumbers, 24118);
    });
  });
}
