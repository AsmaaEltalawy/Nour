import 'package:flutter/animation.dart';

class SplashViewModel {
  SplashViewModel({required TickerProvider vsync, required this.onComplete}) {
    loadingController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    titleController =
        AnimationController(
            vsync: vsync,
            duration: const Duration(milliseconds: 1900),
          )
          ..addStatusListener(_handleTitleStatus)
          ..forward();
  }

  final VoidCallback onComplete;
  late final AnimationController loadingController;
  late final AnimationController titleController;

  void _handleTitleStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) onComplete();
  }

  void dispose() {
    loadingController.dispose();
    titleController.dispose();
  }
}
