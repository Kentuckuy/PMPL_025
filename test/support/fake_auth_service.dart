import 'package:firebase_auth/firebase_auth.dart';
import 'package:pmpl_025/services/auth_service.dart';

class FakeAuthService implements AuthService {
  String? lastEmail;
  String? lastPassword;
  String? loginErrorCode;
  String? loginErrorMessage;
  bool logoutCalled = false;

  @override
  User? get currentUser => null;

  @override
  Stream<User?> get authStateChanges => const Stream<User?>.empty();

  @override
  Future<void> login(String email, String password) async {
    lastEmail = email;
    lastPassword = password;
    if (loginErrorCode != null) {
      throw FirebaseAuthException(
        code: loginErrorCode!,
        message: loginErrorMessage,
      );
    }
  }

  @override
  Future<void> register(String email, String password) async {
    lastEmail = email;
    lastPassword = password;
  }

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }
}
