import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/models/staff.dart';

void main() {
  group('Staff', () {
    test('constructor sets all fields', () {
      final staff = Staff(
        name: 'Pastor John',
        image: 'https://example.com/john.png',
        position: 'Senior Pastor',
      );
      expect(staff.name, 'Pastor John');
      expect(staff.image, 'https://example.com/john.png');
      expect(staff.position, 'Senior Pastor');
    });

    test('position is optional', () {
      final staff = Staff(
        name: 'Jane',
        image: 'https://example.com/jane.png',
      );
      expect(staff.position, isNull);
    });
  });
}
