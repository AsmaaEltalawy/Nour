import 'package:flutter/widgets.dart';
import 'package:nour/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmation = true;
  bool isLoading = false;
  String? errorMessage;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleConfirmationVisibility() {
    obscureConfirmation = !obscureConfirmation;
    notifyListeners();
  }

  Future<AuthResponse?> submit() async {
    if (isLoading) return null;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      return await AuthService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    } on AuthException catch (error) {
      errorMessage = error.message;
      return null;
    } catch (_) {
      errorMessage = 'Unable to create your account. Please try again.';
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
