import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/models/signup_progress.dart';

void main() {
  group('SignupProgress', () {
    test('allows setting signup fields', () {
      final progress = SignupProgress()
        ..firstName = 'John'
        ..lastName = 'Doe'
        ..email = 'john@example.com'
        ..password = 'securePassword123';

      expect(progress.firstName, 'John');
      expect(progress.lastName, 'Doe');
      expect(progress.email, 'john@example.com');
      expect(progress.password, 'securePassword123');
    });

    test('starts with null fields', () {
      final progress = SignupProgress();
      expect(progress.firstName, isNull);
      expect(progress.lastName, isNull);
      expect(progress.email, isNull);
      expect(progress.password, isNull);
    });
  });
}
