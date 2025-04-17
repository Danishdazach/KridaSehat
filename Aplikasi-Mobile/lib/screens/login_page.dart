import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Using the same colors as the onboarding screen
  static const Color primaryColor = Color(0xFF6E7E40);
  static const Color backgroundColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF333333);
  static const Color textSecondaryColor = Color(0xFF666666);
  static const double horizontalPadding = 24.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _login() {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username == 'admin' && password == '1234') {
      Navigator.pushReplacementNamed(context, '/landing');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username atau password salah'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Container(
              height: screenSize.height - MediaQuery.of(context).padding.top,
              padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: _buildLoginForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          // Logo similar to onboarding screen
          Image.asset(
            'assets/images/logo.png',
            width: 40,
            height: 40,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.rocket_launch,
              color: primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'KridaSehat',
            style: TextStyle(
              fontFamily: 'Sora',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: primaryColor,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.arrow_back, color: primaryColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        // Login illustration or icon
        Container(
          height: 140,
          margin: const EdgeInsets.only(bottom: 30),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_outline,
            size: 80,
            color: primaryColor,
          ),
        ),
        const Text(
          'Masuk',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Sora',
            color: textPrimaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Masukkan kredensial Anda untuk melanjutkan',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Sora',
            color: textSecondaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        // Username field
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
            labelStyle: const TextStyle(
              color: textSecondaryColor,
              fontFamily: 'Sora',
            ),
            prefixIcon: const Icon(Icons.person, color: primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: primaryColor, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: primaryColor, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          style: const TextStyle(fontFamily: 'Sora'),
        ),
        const SizedBox(height: 20),
        // Password field
        TextField(
          controller: passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: const TextStyle(
              color: textSecondaryColor,
              fontFamily: 'Sora',
            ),
            prefixIcon: const Icon(Icons.lock, color: primaryColor),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: primaryColor,
              ),
              onPressed: _togglePasswordVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: primaryColor, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: primaryColor, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          style: const TextStyle(fontFamily: 'Sora'),
        ),
        const SizedBox(height: 12),
        // Forgot password option
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Handle forgot password
            },
            style: TextButton.styleFrom(
              foregroundColor: primaryColor,
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Lupa Password?',
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        // Login button
        ElevatedButton(
          onPressed: _login,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 2,
          ),
          child: const Text(
            'Masuk',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Sora',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Registration option
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Belum punya akun? ',
              style: TextStyle(
                fontFamily: 'Sora',
                color: textSecondaryColor,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to registration
              },
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Daftar',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}