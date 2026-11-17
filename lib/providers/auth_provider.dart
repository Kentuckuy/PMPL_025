import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';

import '../repositories/auth_repository.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthRepository? repository})
    : _repository = repository ?? AuthRepository(FirebaseAuthService()) {
    _user = _repository.currentUser;
  }

  final AuthRepository _repository;
  User? _user;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  String? get token => _user?.uid;
  Stream<User?> get authStateChanges => _repository.authStateChanges;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> login(String email, String password) =>
      _repository.login(email, password);

  Future<void> register(String email, String password) =>
      _repository.register(email, password);

  Future<void> logout() => _repository.logout();
}
