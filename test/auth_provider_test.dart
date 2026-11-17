import 'package:flutter_test/flutter_test.dart';
import 'package:pertemuan_3/providers/auth_provider.dart';
import 'package:pertemuan_3/repositories/auth_repository.dart';

import 'support/fake_auth_service.dart';

void main() {
  group('AuthProvider', () {
    late FakeAuthService authService;
    late AuthProvider authProvider;

    setUp(() {
      authService = FakeAuthService();
      authProvider = AuthProvider(repository: AuthRepository(authService));
    });

    test('starts unauthenticated when the service has no current user', () {
      expect(authProvider.user, isNull);
      expect(authProvider.isAuthenticated, isFalse);
      expect(authProvider.token, isNull);
    });

    test('delegates login and trims the email', () async {
      await authProvider.login(' budi@mail.com ', 'rahasia123');

      expect(authService.lastEmail, 'budi@mail.com');
      expect(authService.lastPassword, 'rahasia123');
    });

    test('delegates registration and logout', () async {
      await authProvider.register(' budi@mail.com ', 'rahasia123');
      await authProvider.logout();

      expect(authService.lastEmail, 'budi@mail.com');
      expect(authService.lastPassword, 'rahasia123');
      expect(authService.logoutCalled, isTrue);
    });
  });
}
