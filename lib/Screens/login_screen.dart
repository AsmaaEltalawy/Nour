import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nour/nour_theme.dart';
import 'package:nour/viewmodels/login_view_model.dart';

import 'home_screen.dart';
import 'sign_up_screen.dart';

/// Nour login screen styled to match SplashScreen.
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.onSignIn,
    this.onSignUp,
    this.onForgotPassword,
  });

  final Future<void> Function(String email, String password)? onSignIn;
  final VoidCallback? onSignUp;
  final VoidCallback? onForgotPassword;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final LoginViewModel _viewModel;

  @override
  void dispose() {
    _viewModel.removeListener(_refresh);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel(
      onSignIn: widget.onSignIn,
      onSignUp: widget.onSignUp,
      onForgotPassword: widget.onForgotPassword,
    )..addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _openSignUp() {
    if (widget.onSignUp != null) {
      widget.onSignUp!();
      return;
    }

    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SignUpScreen()));
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (_viewModel.onSignIn == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connect your sign-in logic here.')),
      );
      return;
    }

    final error = await _viewModel.signIn();
    if (error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to sign in. Please check your credentials.'),
        ),
      );
      return;
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NourColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _LoginDecorativeBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 760;

                if (isWide) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 28,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1050),
                        child: Row(
                          children: [
                            Expanded(child: _BrandPanel(compact: false)),
                            const SizedBox(width: 54),
                            Expanded(child: _buildLoginCard()),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _BrandPanel(compact: true),
                          const SizedBox(height: 32),
                          _buildLoginCard(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
      decoration: BoxDecoration(
        color: NourColors.decorationFill.withValues(alpha: 0.075),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: NourColors.decoration.withValues(alpha: 0.22),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: NourColors.black.withValues(alpha: 0.08),
            blurRadius: 32,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: TextStyle(
                fontFamily: NourTypography.logoFont,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: NourColors.white,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Sign in to continue to your account',
              style: TextStyle(
                fontSize: 14,
                color: NourColors.subtitle,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            _buildInput(
              controller: _viewModel.emailController,
              hint: 'Email address',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) return 'Please enter your email address.';
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                  return 'Please enter a valid email address.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildInput(
              controller: _viewModel.passwordController,
              hint: 'Password',
              icon: Icons.lock_outline_rounded,
              obscureText: _viewModel.obscurePassword,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              suffix: IconButton(
                tooltip: _viewModel.obscurePassword
                    ? 'Show password'
                    : 'Hide password',
                onPressed: () {
                  _viewModel.togglePasswordVisibility();
                },
                icon: Icon(
                  _viewModel.obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: NourColors.subtitle,
                  size: 21,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: Checkbox(
                    value: _viewModel.rememberMe,
                    onChanged: (value) {
                      _viewModel.toggleRememberMe(value ?? false);
                    },
                    activeColor: NourColors.accent,
                    checkColor: NourColors.leaf,
                    side: BorderSide(
                      color: NourColors.subtitle.withValues(alpha: 0.7),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Remember me',
                    style: TextStyle(color: NourColors.subtitle, fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: _viewModel.onForgotPassword,
                  style: TextButton.styleFrom(
                    foregroundColor: NourColors.accent,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: NourLayout.buttonHeight,
              child: ElevatedButton(
                onPressed: _viewModel.isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: NourColors.accent,
                  foregroundColor: NourColors.leaf,
                  disabledBackgroundColor: NourColors.accent.withValues(
                    alpha: 0.6,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _viewModel.isLoading
                    ? SizedBox(
                        width: 23,
                        height: 23,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            NourColors.leaf,
                          ),
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.arrow_forward_rounded, size: 22),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: NourColors.subtitle, fontSize: 13),
                  ),
                  TextButton(
                    onPressed: _openSignUp,
                    style: TextButton.styleFrom(
                      foregroundColor: NourColors.accent,
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    Widget? suffix,
    ValueChanged<String>? onSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      onFieldSubmitted: onSubmitted,
      style: TextStyle(color: NourColors.white, fontSize: 15),
      cursorColor: NourColors.accent,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: NourColors.subtitle.withValues(alpha: 0.78),
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: NourColors.accent, size: 22),
        suffixIcon: suffix,
        filled: true,
        fillColor: NourColors.decorationFill.withValues(alpha: 0.08),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: NourColors.decoration.withValues(alpha: 0.35),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: NourColors.accent.withValues(alpha: 0.85),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFFFFA7A7)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFFFFA7A7), width: 1.5),
        ),
        errorStyle: const TextStyle(color: Color(0xFFFFC2C2), fontSize: 11),
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _NourLoginLogo(),
        const SizedBox(height: 18),
        Text(
          'Nour',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: NourTypography.logoFont,
            fontSize: compact ? 42 : 48,
            fontWeight: FontWeight.bold,
            color: NourColors.white,
            letterSpacing: NourTypography.titleLetterSpacing,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Your Health, Our Priority',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: compact ? 16 : 19,
            fontWeight: FontWeight.w600,
            color: NourColors.subtitle,
            letterSpacing: NourTypography.subtitleLetterSpacing,
          ),
        ),
        const SizedBox(height: 26),
        Container(
          width: 48,
          height: 3,
          decoration: BoxDecoration(
            color: NourColors.accent,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Better habits today,\na healthier tomorrow.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            height: 1.7,
            color: NourColors.subtitle,
          ),
        ),
      ],
    );
  }
}

class _NourLoginLogo extends StatelessWidget {
  const _NourLoginLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: NourLayout.logoSize,
      height: NourLayout.logoSize,
      decoration: BoxDecoration(
        color: NourColors.accent,
        borderRadius: BorderRadius.circular(29),
        boxShadow: [
          BoxShadow(
            color: NourColors.black.withValues(alpha: 0.08),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const CustomPaint(painter: _LoginLeafLogoPainter()),
    );
  }
}

class _LoginLeafLogoPainter extends CustomPainter {
  const _LoginLeafLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final leafPaint = Paint()
      ..color = NourColors.leaf
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final stemPaint = Paint()
      ..color = NourColors.leaf
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = NourColors.leafDot
      ..style = PaintingStyle.fill;

    final leftLeaf = Path()
      ..moveTo(center.dx, center.dy + 2)
      ..cubicTo(
        center.dx - 14,
        center.dy + 1,
        center.dx - 19,
        center.dy - 5,
        center.dx - 18,
        center.dy - 15,
      )
      ..cubicTo(
        center.dx - 7,
        center.dy - 15,
        center.dx - 1,
        center.dy - 9,
        center.dx,
        center.dy + 2,
      );

    final rightLeaf = Path()
      ..moveTo(center.dx, center.dy + 3)
      ..cubicTo(
        center.dx + 1,
        center.dy - 10,
        center.dx + 8,
        center.dy - 16,
        center.dx + 19,
        center.dy - 17,
      )
      ..cubicTo(
        center.dx + 20,
        center.dy - 5,
        center.dx + 13,
        center.dy + 2,
        center.dx,
        center.dy + 3,
      );

    canvas.drawPath(leftLeaf, leafPaint);
    canvas.drawPath(rightLeaf, leafPaint);
    canvas.drawLine(
      Offset(center.dx, center.dy + 2),
      Offset(center.dx, center.dy + 20),
      stemPaint,
    );
    canvas.drawLine(
      Offset(center.dx - 10, center.dy + 20),
      Offset(center.dx + 10, center.dy + 20),
      stemPaint,
    );
    canvas.drawCircle(Offset(center.dx, center.dy - 21), 2.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LoginDecorativeBackground extends StatelessWidget {
  const _LoginDecorativeBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final innerSize = math.min(width * 0.78, height * 0.98);
          final outerSize = math.min(width * 1.02, height * 1.3);

          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                width: innerSize,
                height: innerSize,
                left: (width - innerSize) / 2,
                top: (height - innerSize) / 2 - 10,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: NourColors.decoration.withValues(alpha: 0.09),
                    ),
                  ),
                ),
              ),
              Positioned(
                width: outerSize,
                height: outerSize,
                left: (width - outerSize) / 2,
                top: (height - outerSize) / 2 - 10,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: NourColors.decoration.withValues(alpha: 0.035),
                      width: 40,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -105,
                left: -105,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: NourColors.decorationFill.withValues(alpha: 0.075),
                  ),
                ),
              ),
              Positioned(
                right: -95,
                bottom: -155,
                child: Container(
                  width: 295,
                  height: 295,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: NourColors.decorationFill.withValues(alpha: 0.055),
                  ),
                ),
              ),
              Positioned(
                top: height * 0.15,
                right: width * 0.12,
                child: Transform.rotate(
                  angle: 0.65,
                  child: const _LoginDecorativeLeaf(),
                ),
              ),
              if (width < 760)
                Positioned(
                  left: -40,
                  bottom: height * 0.12,
                  child: Transform.rotate(
                    angle: -0.65,
                    child: const _LoginDecorativeLeaf(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _LoginDecorativeLeaf extends StatelessWidget {
  const _LoginDecorativeLeaf();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 76,
      height: 120,
      child: CustomPaint(painter: _LoginDecorativeLeafPainter()),
    );
  }
}

class _LoginDecorativeLeafPainter extends CustomPainter {
  const _LoginDecorativeLeafPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = NourColors.decoration.withValues(alpha: 0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path()
      ..moveTo(size.width * 0.5, size.height)
      ..cubicTo(
        -size.width * 0.1,
        size.height * 0.67,
        size.width * 0.12,
        size.height * 0.2,
        size.width,
        0,
      )
      ..cubicTo(
        size.width * 0.88,
        size.height * 0.5,
        size.width * 0.9,
        size.height * 0.85,
        size.width * 0.5,
        size.height,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
