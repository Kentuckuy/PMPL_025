import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pertemuan_3/repositories/auth_repository.dart';

import '../support/fake_auth_service.dart';

void main() {
  group('AuthRepository.login', () {
    late FakeAuthService authService;
    late AuthRepository repository;

    setUp(() {
      authService = FakeAuthService();
      repository = AuthRepository(authService);
    });

    test('passes trimmed email and password to the service', () async {
      await repository.login(' budi@mail.com ', 'rahasia123');

      expect(authService.lastEmail, 'budi@mail.com');
      expect(authService.lastPassword, 'rahasia123');
    });

    test('propagates authentication exceptions', () async {
      authService
        ..loginErrorCode = 'wrong-password'
        ..loginErrorMessage = 'Password salah';

      await expectLater(
        repository.login('budi@mail.com', 'passwordsalah'),
        throwsA(
          isA<FirebaseAuthException>()
              .having((error) => error.code, 'code', 'wrong-password')
              .having((error) => error.message, 'message', 'Password salah'),
        ),
      );
    });
  });
}
