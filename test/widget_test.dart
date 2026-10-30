import 'package:flutter_test/flutter_test.dart';

import 'package:nour/main.dart' hide SplashScreen;
import '../lib/Screens/login_screen.dart' show LoginScreen;
import '../lib/Screens/splash_screen.dart' show SplashScreen;

void main() {
  testWidgets('flows from splash screen to login', (WidgetTester tester) async {
    await tester.pumpWidget(const NourApp());
    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1900));
    await tester.pump(const Duration(milliseconds: 450));

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
