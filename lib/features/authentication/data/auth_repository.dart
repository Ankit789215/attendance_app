import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository that wraps Supabase Auth client operations.
///
/// This is the data layer — it handles raw communication with Supabase
/// and exposes typed results. No business logic belongs here.
class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  /// Signs in a user with email and password.
  /// Throws [AuthException] on failure.
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Sends a password reset email to the given address.
  /// Throws [AuthException] if the email is not found or on failure.
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  /// Returns the current active session, or `null` if none exists.
  Session? getCurrentSession() {
    return _client.auth.currentSession;
  }

  /// Returns the currently authenticated user, or `null` if none.
  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  /// Stream of auth state changes (sign in, sign out, token refresh, etc.).
  Stream<AuthState> onAuthStateChange() {
    return _client.auth.onAuthStateChange;
  }
}

/// Provides a singleton [AuthRepository] instance backed by the
/// default Supabase client.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(Supabase.instance.client);
});
