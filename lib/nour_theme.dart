import 'package:flutter/material.dart';

abstract final class NourColors {
  static const background = Color(0xFF095C64);
  static const accent = Color(0xFFC4F1DD);
  static const subtitle = Color(0xFFD0E2DC);
  static const footer = Color(0xFFB9D2C8);
  static const leaf = Color(0xFF19483F);
  static const leafDot = Color(0xFF329B83);
  static const decoration = Color(0xFFB8D7C9);
  static const decorationFill = Color(0xFFB5D6C7);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
}

abstract final class NourTypography {
  static const appFont = 'Avenir';
  static const logoFont = 'Georgia';
  static const titleSize = 34.0;
  static const subtitleSize = 16.0;
  static const footerSize = 10.0;
  static const titleLetterSpacing = -1.2;
  static const subtitleLetterSpacing = 0.15;
  static const footerLetterSpacing = 1.5;
}

abstract final class NourLayout {
  static const contentHorizontalPadding = 24.0;
  static const logoSize = 96.0;
  static const logoTitleSpacing = 24.0;
  static const titleSubtitleSpacing = 12.0;
  static const footerBottom = 28.0;
  static const footerLineWidth = 96.0;
  static const footerLineHeight = 4.0;
  static const fieldHeight = 56.0;
  static const buttonHeight = 56.0;
}
