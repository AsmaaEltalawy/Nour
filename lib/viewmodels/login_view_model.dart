import 'package:flutter/widgets.dart';
import 'package:nour/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({this.onSignIn, this.onSignUp, this.onForgotPassword});

  // Authentication and navigation callbacks
  final Future<void> Function(String email, String password)? onSignIn;
  final VoidCallback? onSignUp;
  final VoidCallback? onForgotPassword;

  // Form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // UI state
  bool obscurePassword = true;
  bool rememberMe = false;
  bool isLoading = false;

  /// Show or hide the password.
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  /// Update the Remember Me checkbox.
  void toggleRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  /// Sign in using the injected callback or the application's auth service.
  ///
  /// Returns null on success and the caught error if authentication fails.
  Future<Object?> signIn() async {
    if (isLoading) {
      return null;
    }

    isLoading = true;
    notifyListeners();

    try {
      if (onSignIn != null) {
        await onSignIn!(emailController.text.trim(), passwordController.text);
      } else {
        await AuthService.signIn(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
      }

      return null;
    } catch (error) {
      return error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
