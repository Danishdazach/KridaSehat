import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_page.dart';
import 'screens/lupa_password.dart';
import 'screens/onboarding_screen.dart';
import 'screens/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Flutter Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/boarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/landing': (context) => const LandingPage(),
      },
    );
  }
}
