import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../data/auth_repository.dart';

/// Service that orchestrates authentication business logic.
///
/// Sits between the presentation layer and [AuthRepository].
/// Handles "Remember Me" persistence, validation orchestration,
/// and session lifecycle management.
class AuthService {
  final AuthRepository _repository;
  final SharedPreferences _prefs;

  AuthService(this._repository, this._prefs);

  /// Attempts to log in with the given credentials.
  ///
  /// If [rememberMe] is `true`, the preference is persisted so the
  /// session survives app restarts. Otherwise the preference is cleared,
  /// meaning `checkSession` will force a sign-out on next cold start.
  Future<AuthResponse> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final response = await _repository.signInWithEmail(
      email: email.trim(),
      password: password,
    );

    // Persist the "remember me" preference
    await _prefs.setBool(AppConstants.rememberMeKey, rememberMe);

    return response;
  }

  /// Signs out the user and clears the remember-me preference.
  Future<void> logout() async {
    await _prefs.remove(AppConstants.rememberMeKey);
    await _repository.signOut();
  }

  /// Checks whether an active session should be honoured.
  ///
  /// Returns `true` if:
  ///   1. There is an active Supabase session, AND
  ///   2. The user previously checked "Remember Me".
  ///
  /// If a session exists but remember-me is `false`, the session is
  /// forcibly cleared so the user must log in again.
  Future<bool> checkSession() async {
    final session = _repository.getCurrentSession();
    final rememberMe = _prefs.getBool(AppConstants.rememberMeKey) ?? false;

    if (session != null && rememberMe) {
      return true;
    }

    // Session exists but user didn't want to be remembered — clear it.
    if (session != null && !rememberMe) {
      await _repository.signOut();
    }

    return false;
  }

  /// Sends a password-reset email to [email].
  Future<void> resetPassword(String email) async {
    await _repository.resetPassword(email.trim());
  }

  /// Convenience getter for the current user.
  User? get currentUser => _repository.getCurrentUser();

  /// Stream of auth state changes forwarded from the repository.
  Stream<AuthState> get onAuthStateChange => _repository.onAuthStateChange();
}

/// Provides [SharedPreferences] — must be overridden in `ProviderScope`
/// with the pre-initialised instance from `main()`.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope',
  );
});

/// Provides a singleton [AuthService].
final authServiceProvider = Provider<AuthService>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthService(repository, prefs);
});
