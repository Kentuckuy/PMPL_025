import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository(this._authService);

  final AuthService _authService;

  User? get currentUser => _authService.currentUser;
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<void> login(String email, String password) {
    return _authService.login(email.trim(), password);
  }

  Future<void> register(String email, String password) {
    return _authService.register(email.trim(), password);
  }

  Future<void> logout() => _authService.logout();
}
