import 'package:flutter/widgets.dart';

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

  /// Sign in using the supplied authentication callback.
  ///
  /// Returns null on success or when no callback is configured.
  /// Returns the caught error if authentication fails.
  Future<Object?> signIn() async {
    final callback = onSignIn;

    if (callback == null || isLoading) {
      return null;
    }

    isLoading = true;
    notifyListeners();

    try {
      await callback(emailController.text.trim(), passwordController.text);

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
