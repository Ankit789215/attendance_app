import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/auth_service.dart';

// ---------------------------------------------------------------------------
// Auth State
// ---------------------------------------------------------------------------

/// Represents the current authentication state of the app.
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final User user;
  const Authenticated(this.user);
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

// ---------------------------------------------------------------------------
// Auth Notifier
// ---------------------------------------------------------------------------

/// Manages authentication state and exposes actions to the UI.
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthInitial());

  /// Checks if an existing session should be honoured.
  /// Called once on app startup (splash screen).
  Future<void> checkSession() async {
    state = const AuthLoading();
    try {
      final isLoggedIn = await _authService.checkSession();
      if (isLoggedIn) {
        final user = _authService.currentUser;
        state = user != null
            ? Authenticated(user)
            : const Unauthenticated();
      } else {
        state = const Unauthenticated();
      }
    } on AuthException catch (e) {
      state = AuthError(e.message);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Attempts login with email + password.
  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    state = const AuthLoading();
    try {
      final response = await _authService.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      final user = response.user;
      if (user != null) {
        state = Authenticated(user);
      } else {
        state = const AuthError('Login failed. Please try again.');
      }
    } on AuthException catch (e) {
      state = AuthError(e.message);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Signs out the user.
  Future<void> logout() async {
    state = const AuthLoading();
    try {
      await _authService.logout();
      state = const Unauthenticated();
    } on AuthException catch (e) {
      state = AuthError(e.message);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Sends a password-reset email.
  Future<bool> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
      return true;
    } on AuthException {
      return false;
    } catch (_) {
      return false;
    }
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

/// Global auth state provider used by the router and UI screens.
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
