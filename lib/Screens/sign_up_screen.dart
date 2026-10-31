import 'package:flutter/material.dart';
import 'package:nour/nour_theme.dart';
import 'package:nour/viewmodels/sign_up_view_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late final SignUpViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SignUpViewModel()..addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_refresh);
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate() || _viewModel.isLoading) return;

    final response = await _viewModel.submit();
    if (!mounted) return;
    if (_viewModel.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_viewModel.errorMessage!)));
    } else if (response?.session == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created. Check your email to confirm it.'),
        ),
      );
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Please enter your email address.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NourColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontFamily: NourTypography.logoFont,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: NourColors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Start your journey to better health.',
                      style: TextStyle(
                        color: NourColors.subtitle,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _input(
                      controller: _viewModel.emailController,
                      hint: 'Email address',
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),
                    _input(
                      controller: _viewModel.passwordController,
                      hint: 'Password',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _viewModel.obscurePassword,
                      suffix: IconButton(
                        onPressed: _viewModel.togglePasswordVisibility,
                        icon: Icon(
                          _viewModel.obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: NourColors.subtitle,
                        ),
                      ),
                      validator: (value) {
                        if ((value ?? '').length < 6) {
                          return 'Password must be at least 6 characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _input(
                      controller: _viewModel.confirmPasswordController,
                      hint: 'Confirm password',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _viewModel.obscureConfirmation,
                      suffix: IconButton(
                        onPressed: _viewModel.toggleConfirmationVisibility,
                        icon: Icon(
                          _viewModel.obscureConfirmation
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: NourColors.subtitle,
                        ),
                      ),
                      validator: (value) {
                        if (value != _viewModel.passwordController.text) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      height: NourLayout.buttonHeight,
                      child: ElevatedButton(
                        onPressed: _viewModel.isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: NourColors.accent,
                          foregroundColor: NourColors.leaf,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _viewModel.isLoading
                            ? const SizedBox(
                                width: 23,
                                height: 23,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Already have an account? Sign In'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: NourColors.white, fontSize: 15),
      cursorColor: NourColors.accent,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: NourColors.subtitle.withValues(alpha: 0.78),
        ),
        prefixIcon: Icon(icon, color: NourColors.accent),
        suffixIcon: suffix,
        filled: true,
        fillColor: NourColors.decorationFill.withValues(alpha: 0.08),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: NourColors.decoration.withValues(alpha: 0.35),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: NourColors.decoration.withValues(alpha: 0.35),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: NourColors.accent, width: 1.5),
        ),
        errorStyle: const TextStyle(color: Color(0xFFFFC2C2), fontSize: 11),
      ),
    );
  }
}
