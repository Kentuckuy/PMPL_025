import 'package:flutter_test/flutter_test.dart';
import 'package:pmpl_025/validators/auth_validator.dart';

void main() {
  group('AuthValidator.validateEmail', () {
    test('accepts a valid email', () {
      expect(AuthValidator.validateEmail('budi@mail.com'), isNull);
    });

    test('rejects empty and whitespace-only input', () {
      expect(AuthValidator.validateEmail(''), 'Email tidak boleh kosong');
      expect(AuthValidator.validateEmail('   '), 'Email tidak boleh kosong');
      expect(AuthValidator.validateEmail(null), 'Email tidak boleh kosong');
    });

    test('rejects malformed email addresses', () {
      expect(AuthValidator.validateEmail('budi'), 'Format email tidak valid');
      expect(
        AuthValidator.validateEmail('budi@mail'),
        'Format email tidak valid',
      );
    });
  });

  group('AuthValidator.validatePassword', () {
    test('accepts passwords of at least six characters', () {
      expect(AuthValidator.validatePassword('rahasia123'), isNull);
      expect(AuthValidator.validatePassword('123456'), isNull);
    });

    test('rejects empty and null passwords', () {
      expect(AuthValidator.validatePassword(''), 'Password tidak boleh kosong');
      expect(
        AuthValidator.validatePassword(null),
        'Password tidak boleh kosong',
      );
    });

    test('rejects passwords shorter than six characters', () {
      expect(
        AuthValidator.validatePassword('12345'),
        'Password minimal 6 karakter',
      );
    });
  });
}
