import 'package:flutter/material.dart';
import 'package:nour/nour_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Screens/splash_screen.dart';
import 'Screens/home_screen.dart';
export 'Screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yjoxstqmlqilsisotcsw.supabase.co',
    publishableKey: 'sb_publishable_vaEYw_i1nYGtVANtpfbP4g_0kfJeq8Q',
  );

  runApp(const NourApp());
}

class NourApp extends StatelessWidget {
  const NourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nour',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: NourTypography.appFont,
        scaffoldBackgroundColor: NourColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: NourColors.accent,
          brightness: Brightness.dark,
        ),
      ),
      home: const SplashScreen(),
      routes: {'/home': (_) => const HomeScreen()},
    );
  }
}
