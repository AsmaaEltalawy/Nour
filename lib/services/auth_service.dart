import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService._();

  static final _client = Supabase.instance.client;

  static User? get currentUser => _client.auth.currentUser;

  static Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) {
    return _client.auth.signUp(email: email, password: password);
  }

  static Future<void> signOut() => _client.auth.signOut();
}
