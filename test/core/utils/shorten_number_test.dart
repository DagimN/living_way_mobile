import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/utils/shorten_number.dart';

void main() {
  group('shortenNumber', () {
    test('returns value as string when under 1000', () {
      expect(shortenNumber(0), '0');
      expect(shortenNumber(999), '999');
      expect(shortenNumber(42), '42');
    });

    test('shortens thousands with K suffix', () {
      expect(shortenNumber(1000), '1.0K');
      expect(shortenNumber(1500), '1.5K');
      expect(shortenNumber(999999), '1.0K');
    });

    test('handles large values in thousands branch', () {
      final result = shortenNumber(50000);
      expect(result.endsWith('K'), isTrue);
    });
  });
}
