import 'package:flutter_test/flutter_test.dart';
import 'package:pmpl_025/models/user_model.dart';

void main() {
  group('UserModel', () {
    const userJson = {
      'id': 1,
      'email': 'budi@mail.com',
      'first_name': 'Budi',
      'last_name': 'Santoso',
      'avatar': 'https://example.com/avatar.png',
    };
    const user = UserModel(
      id: 1,
      email: 'budi@mail.com',
      firstName: 'Budi',
      lastName: 'Santoso',
      avatar: 'https://example.com/avatar.png',
    );

    test('parses JSON fields', () {
      expect(UserModel.fromJson(userJson), user);
      expect(user.name, 'Budi Santoso');
    });

    test('serializes fields using API keys', () {
      expect(user.toJson(), userJson);
    });

    test('round-trips JSON without losing data', () {
      expect(UserModel.fromJson(userJson).toJson(), userJson);
    });

    test('compares by value and uses a matching hash code', () {
      final duplicate = UserModel.fromJson(userJson);

      expect(duplicate, user);
      expect(duplicate.hashCode, user.hashCode);
      expect({user, duplicate}, hasLength(1));
    });

    test('copyWith changes selected fields without mutating the source', () {
      final updated = user.copyWith(firstName: 'Budi Baru');

      expect(updated.firstName, 'Budi Baru');
      expect(updated.id, user.id);
      expect(updated.email, user.email);
      expect(updated.lastName, user.lastName);
      expect(updated.avatar, user.avatar);
      expect(user.firstName, 'Budi');
    });
  });
}
