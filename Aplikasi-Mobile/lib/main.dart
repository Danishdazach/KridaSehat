import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Import semua halaman
import 'splashScreen/splash_screen.dart';
import 'pagesLogin/login_page.dart';
import 'pagesLogin/lupa_password_page.dart';
import 'splashScreen/onboarding_screen.dart';
import 'screens/landing_page.dart';

// Import notifikasi
import 'services/notification_service.dart';
import 'widgets/notification_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientasi ke portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationService _notificationService = NotificationService.instance;

  @override
  void initState() {
    super.initState();
    _notificationService.init();
  }

  @override
  void dispose() {
    _notificationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationProvider(
      notificationService: _notificationService,
      child: MaterialApp(
        title: 'KridaSehat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF6E7E40),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6E7E40),
            primary: const Color(0xFF6E7E40),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF6E7E40),
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6E7E40),
              foregroundColor: Colors.white,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/boarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginPage(),
          '/forgot-password': (context) => const ForgotPasswordPage(),
          '/landing': (context) => const LandingPage(),
        },
      ),
    );
  }
}
