import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nour/services/auth_service.dart';

import 'login_screen.dart';
import 'home_screen.dart';
import '../nour_theme.dart';
import '../viewmodels/splash_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final SplashViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = SplashViewModel(vsync: this, onComplete: _openLogin);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _openLogin() {
    if (!mounted) return;
    if (AuthService.currentUser != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            LoginScreen(onSignIn: _signIn),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            ),
        transitionDuration: const Duration(milliseconds: 450),
        reverseTransitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  Future<void> _signIn(String email, String password) async {
    await AuthService.signIn(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NourColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background decorations.
          const _DecorativeShapes(),

          // Main content.
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: NourLayout.contentHorizontalPadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _NourLogo(),

                    const SizedBox(height: NourLayout.logoTitleSpacing),

                    // Reveal each letter smoothly in sequence.
                    AnimatedBuilder(
                      animation: _viewModel.titleController,
                      builder: (context, child) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var index = 0; index < 4; index++)
                              _AnimatedTitleLetter(
                                letter: 'Nour'[index],
                                animation: CurvedAnimation(
                                  parent: _viewModel.titleController,
                                  curve: Interval(
                                    index * 0.14,
                                    0.48 + (index * 0.14),
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: NourLayout.titleSubtitleSpacing),

                    const Text(
                      'Your Health, Our Priority',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: NourTypography.subtitleSize,
                        fontWeight: FontWeight.w500,
                        color: NourColors.subtitle,
                        letterSpacing: NourTypography.subtitleLetterSpacing,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom loading line and tagline.
          Positioned(
            left: 0,
            right: 0,
            bottom: NourLayout.footerBottom,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LoadingLine(animation: _viewModel.loadingController),

                  const SizedBox(height: 12),

                  const Text(
                    'A LITTLE CARE GOES A LONG WAY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: NourTypography.footerSize,
                      fontWeight: FontWeight.w700,
                      color: NourColors.footer,
                      letterSpacing: NourTypography.footerLetterSpacing,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedTitleLetter extends StatelessWidget {
  const _AnimatedTitleLetter({required this.letter, required this.animation});

  final String letter;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - animation.value)),
            child: child,
          ),
        );
      },
      child: Text(
        letter,
        style: const TextStyle(
          fontFamily: NourTypography.logoFont,
          fontSize: NourTypography.titleSize,
          fontWeight: FontWeight.bold,
          color: NourColors.white,
          letterSpacing: NourTypography.titleLetterSpacing,
          height: 1.2,
        ),
      ),
    );
  }
}

// --------------------------------------------------
// LOGO
// --------------------------------------------------

class _NourLogo extends StatelessWidget {
  const _NourLogo();

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
      child: const CustomPaint(painter: _LeafLogoPainter()),
    );
  }
}

class _LeafLogoPainter extends CustomPainter {
  const _LeafLogoPainter();

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

    // Left leaf.
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

    // Right leaf.
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

    // Stem.
    canvas.drawLine(
      Offset(center.dx, center.dy + 2),
      Offset(center.dx, center.dy + 20),
      stemPaint,
    );

    // Ground line.
    canvas.drawLine(
      Offset(center.dx - 10, center.dy + 20),
      Offset(center.dx + 10, center.dy + 20),
      stemPaint,
    );

    // Small decorative dot.
    canvas.drawCircle(Offset(center.dx, center.dy - 21), 2.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --------------------------------------------------
// BACKGROUND DECORATIONS
// --------------------------------------------------

class _DecorativeShapes extends StatelessWidget {
  const _DecorativeShapes();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Large central circle outline.
              Positioned(
                width: math.min(width * 0.78, height * 0.98),
                height: math.min(width * 0.78, height * 0.98),
                left: (width - math.min(width * 0.78, height * 0.98)) / 2,
                top: (height - math.min(width * 0.78, height * 0.98)) / 2 - 10,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: NourColors.decoration.withValues(alpha: 0.09),
                      width: 1,
                    ),
                  ),
                ),
              ),

              // Outer translucent circle.
              Positioned(
                width: math.min(width * 1.02, height * 1.3),
                height: math.min(width * 1.02, height * 1.3),
                left: (width - math.min(width * 1.02, height * 1.3)) / 2,
                top: (height - math.min(width * 1.02, height * 1.3)) / 2 - 10,
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

              // Top-left circle.
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

              // Bottom-right circle.
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

              // Outlined leaf at the top-right.
              Positioned(
                top: height * 0.15,
                right: width * 0.12,
                child: Transform.rotate(
                  angle: 0.65,
                  child: const _DecorativeLeaf(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DecorativeLeaf extends StatelessWidget {
  const _DecorativeLeaf();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      height: 120,
      child: CustomPaint(painter: _DecorativeLeafPainter()),
    );
  }
}

class _DecorativeLeafPainter extends CustomPainter {
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

// --------------------------------------------------
// BOTTOM LOADING LINE
// --------------------------------------------------

class _LoadingLine extends StatelessWidget {
  const _LoadingLine({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: NourLayout.footerLineWidth,
          height: NourLayout.footerLineHeight,
          decoration: BoxDecoration(
            color: NourColors.footer.withValues(alpha: 0.30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Align(
            alignment: Alignment(-1 + (animation.value * 2), 0),
            child: Container(
              width: 20,
              height: NourLayout.footerLineHeight,
              decoration: BoxDecoration(
                color: NourColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }
}
