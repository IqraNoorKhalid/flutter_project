// lib/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_session.dart';

class AuthNotifier extends StateNotifier<UserSession?> {
  AuthNotifier() : super(null) {
    _restore();
  }

  static const _kLoggedIn = 'auth_logged_in';
  static const _kEmail = 'auth_email';
  static const _kName = 'auth_display_name';

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_kLoggedIn) != true) return;
    final email = prefs.getString(_kEmail);
    final name = prefs.getString(_kName);
    if (email == null || email.isEmpty) return;
    state = UserSession(
      email: email,
      displayName: name ?? email.split('@').first,
    );
  }

  /// Demo login: any email with @ and password length ≥ 6.
  Future<String?> login({required String email, required String password}) async {
    final trimmed = email.trim();
    if (!trimmed.contains('@') || trimmed.length < 5) {
      return 'Enter a valid email address.';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    final localPart = trimmed.split('@').first;
    final displayName = localPart.isEmpty
        ? 'Shopper'
        : '${localPart[0].toUpperCase()}${localPart.length > 1 ? localPart.substring(1).toLowerCase() : ''}';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, true);
    await prefs.setString(_kEmail, trimmed);
    await prefs.setString(_kName, displayName);

    state = UserSession(email: trimmed, displayName: displayName);
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLoggedIn);
    await prefs.remove(_kEmail);
    await prefs.remove(_kName);
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, UserSession?>((ref) {
  return AuthNotifier();
});
