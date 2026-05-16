import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/utils/security_functions.dart';
import '../../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    await initTestEnvironment();
  });

  group('encrypt and decrypt', () {
    test('round-trips plain text', () {
      const plainText = 'Hello, Living Way!';
      final encrypted = encrypt(plainText);
      final decrypted = decrypt(encrypted);
      expect(decrypted, plainText);
    });

    test('produces different ciphertext for same input is deterministic', () {
      const plainText = 'test message';
      expect(encrypt(plainText), encrypt(plainText));
    });

    test('handles unicode characters', () {
      const plainText = 'ሰላም ዓለም';
      expect(decrypt(encrypt(plainText)), plainText);
    });
  });
}
