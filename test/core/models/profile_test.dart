import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/models/profile.dart';

void main() {
  group('Profile', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'user-123',
        'firstName': 'John',
        'lastName': 'Doe',
        'profileImage': 'https://example.com/avatar.png',
        'isAnonymous': false,
        'tokenId': 'token-abc',
        'passwordExists': true,
      };
      final profile = Profile.fromJson(json);
      expect(profile.id, 'user-123');
      expect(profile.firstName, 'John');
      expect(profile.lastName, 'Doe');
      expect(profile.profileImageUrl, 'https://example.com/avatar.png');
      expect(profile.isAnonymous, isFalse);
      expect(profile.tokenId, 'token-abc');
      expect(profile.passwordExists, isTrue);
    });

    test('fromJson defaults passwordExists to false', () {
      final profile = Profile.fromJson({
        'id': '1',
        'firstName': 'A',
        'lastName': 'B',
        'isAnonymous': true,
      });
      expect(profile.passwordExists, isFalse);
    });

    test('constructor sets defaults', () {
      final profile = Profile(id: '1', firstName: 'Test', lastName: 'User');
      expect(profile.isAnonymous, isTrue);
      expect(profile.passwordExists, isFalse);
    });
  });
}
