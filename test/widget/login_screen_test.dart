import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pertemuan_3/providers/auth_provider.dart';
import 'package:pertemuan_3/repositories/auth_repository.dart';
import 'package:pertemuan_3/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../support/fake_auth_service.dart';

Widget _createSut(FakeAuthService authService) {
  return ChangeNotifierProvider(
    create: (_) => AuthProvider(repository: AuthRepository(authService)),
    child: const MaterialApp(home: LoginScreen()),
  );
}

void main() {
  group('LoginScreen', () {
    testWidgets('renders the login fields and action', (tester) async {
      await tester.pumpWidget(_createSut(FakeAuthService()));

      expect(find.byKey(const ValueKey('emailField')), findsOneWidget);
      expect(find.byKey(const ValueKey('passwordField')), findsOneWidget);
      expect(find.byKey(const ValueKey('loginButton')), findsOneWidget);
    });

    testWidgets('shows validation feedback for empty input', (tester) async {
      final authService = FakeAuthService();
      await tester.pumpWidget(_createSut(authService));

      await tester.tap(find.byKey(const ValueKey('loginButton')));
      await tester.pump();

      expect(find.text('Email tidak boleh kosong'), findsOneWidget);
      expect(authService.lastEmail, isNull);
    });

    testWidgets('shows success feedback after a valid login', (tester) async {
      final authService = FakeAuthService();
      await tester.pumpWidget(_createSut(authService));
      await tester.enterText(
        find.byKey(const ValueKey('emailField')),
        'budi@mail.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('passwordField')),
        'rahasia123',
      );

      await tester.tap(find.byKey(const ValueKey('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text('Login berhasil!'), findsOneWidget);
      expect(authService.lastEmail, 'budi@mail.com');
    });

    testWidgets('shows an error when authentication fails', (tester) async {
      final authService = FakeAuthService()
        ..loginErrorCode = 'wrong-password'
        ..loginErrorMessage = 'Password salah';
      await tester.pumpWidget(_createSut(authService));
      await tester.enterText(
        find.byKey(const ValueKey('emailField')),
        'budi@mail.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('passwordField')),
        'passwordsalah',
      );

      await tester.tap(find.byKey(const ValueKey('loginButton')));
      await tester.pumpAndSettle();

      expect(
        find.text('Kata sandi salah. Silakan periksa kembali.'),
        findsOneWidget,
      );
    });
  });
}
