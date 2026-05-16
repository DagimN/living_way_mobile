import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/models/translation.dart';

void main() {
  group('Translation', () {
    test('fromMap and toMap round-trip', () {
      final map = {
        'name': 'NKJV',
        'path': '/path/to/nkjv.json',
        'status': 'ready',
        'isDefault': true,
      };
      final translation = Translation.fromMap(map);
      expect(translation.name, 'NKJV');
      expect(translation.path, '/path/to/nkjv.json');
      expect(translation.status, TranslationStatus.ready);
      expect(translation.isDefault, isTrue);
      expect(translation.toMap(), map);
    });

    test('defaults status to undefined and isDefault to false', () {
      final translation = Translation.fromMap({'name': 'NIV'});
      expect(translation.status, TranslationStatus.undefined);
      expect(translation.isDefault, isFalse);
    });

    test('toString returns encoded map', () {
      final translation = Translation(name: 'NASB', status: TranslationStatus.pending);
      expect(translation.toString(), contains('NASB'));
    });
  });

  group('TranslationStatus', () {
    test('fromString returns correct status', () {
      expect(TranslationStatus.fromString('ready'), TranslationStatus.ready);
      expect(TranslationStatus.fromString('pending'), TranslationStatus.pending);
      expect(TranslationStatus.fromString('available'), TranslationStatus.available);
      expect(TranslationStatus.fromString('unknown'), TranslationStatus.undefined);
    });
  });
}
