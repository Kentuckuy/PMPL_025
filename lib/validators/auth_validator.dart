class AuthValidator {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? validateEmail(String? email) {
    final value = email?.trim() ?? '';
    if (value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!_emailPattern.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (password.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }
}
