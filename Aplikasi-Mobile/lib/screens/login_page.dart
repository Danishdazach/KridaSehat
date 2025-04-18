import 'package:flutter/material.dart';
import 'package:kridasehat/screens/lupa_password.dart';  // Import the ForgotPasswordPage

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
  
  // Validation state variables
  bool _usernameHasError = false;
  bool _passwordHasError = false;
  bool _usernameIsValid = false;
  bool _passwordIsValid = false;
  String _usernameErrorText = '';
  String _passwordErrorText = '';

  static const Color primaryColor = Color(0xFF6E7E40);
  static const Color backgroundColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF333333);
  static const Color textSecondaryColor = Color(0xFF666666);
  static const Color errorColor = Colors.redAccent;
  static const Color successColor = Color(0xFF4CAF50);
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
    
    // Add listeners to controllers for real-time validation
    usernameController.addListener(_validateUsername);
    passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    usernameController.removeListener(_validateUsername);
    passwordController.removeListener(_validatePassword);
    usernameController.dispose();
    passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  // Username validation logic
  void _validateUsername() {
    setState(() {
      if (usernameController.text.isEmpty) {
        _usernameHasError = true;
        _usernameIsValid = false;
        _usernameErrorText = 'Username tidak boleh kosong';
      } else if (usernameController.text.length < 3) {
        _usernameHasError = true;
        _usernameIsValid = false;
        _usernameErrorText = 'Username minimal 3 karakter';
      } else {
        _usernameHasError = false;
        _usernameIsValid = true;
        _usernameErrorText = '';
      }
    });
  }
  
  // Password validation logic
  void _validatePassword() {
    setState(() {
      if (passwordController.text.isEmpty) {
        _passwordHasError = true;
        _passwordIsValid = false;
        _passwordErrorText = 'Password tidak boleh kosong';
      } else if (passwordController.text.length < 4) {
        _passwordHasError = true;
        _passwordIsValid = false;
        _passwordErrorText = 'Password minimal 4 karakter';
      } else {
        _passwordHasError = false;
        _passwordIsValid = true;
        _passwordErrorText = '';
      }
    });
  }

  void _login() {
    // Force validation before login attempt
    _validateUsername();
    _validatePassword();
    
    // Only proceed if both fields are valid
    if (!_usernameHasError && !_passwordHasError) {
      String username = usernameController.text;
      String password = passwordController.text;

      if (username == 'admin' && password == '1234') {
        Navigator.pushReplacementNamed(context, '/landing');
      } else {
        // Clear the text fields when credentials are incorrect
        usernameController.clear();
        passwordController.clear();
        
        setState(() {
          _usernameHasError = false;  // Reset validation states
          _passwordHasError = false;
          _usernameIsValid = false;
          _passwordIsValid = false;
          _usernameErrorText = '';
          _passwordErrorText = '';
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username atau password salah'),
            backgroundColor: errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get keyboard visibility for responsive layout
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    
    // Adjust spacing based on keyboard visibility
    final double logoSize = isKeyboardVisible ? 60 : 120;
    final double topPadding = isKeyboardVisible ? 5 : 30;
    final double betweenFieldsPadding = isKeyboardVisible ? 8 : 16;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      // Changed to true to allow scrolling with keyboard
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                         MediaQuery.of(context).padding.top - 
                         MediaQuery.of(context).padding.bottom,
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildLoginForm(
                      logoSize: logoSize,
                      topPadding: topPadding, 
                      betweenFieldsPadding: betweenFieldsPadding,
                      isKeyboardVisible: isKeyboardVisible
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
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
              Navigator.pushReplacementNamed(context, '/boarding');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm({
    required double logoSize,
    required double topPadding,
    required double betweenFieldsPadding,
    required bool isKeyboardVisible,
  }) {
    // Adjust text size based on keyboard visibility
    final double titleSize = isKeyboardVisible ? 22 : 28;
    final double subtitleSize = isKeyboardVisible ? 13 : 16;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: topPadding),
        if (!isKeyboardVisible || logoSize > 0)
          Container(
            height: logoSize,
            margin: EdgeInsets.only(bottom: isKeyboardVisible ? 5 : 20),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline,
              size: logoSize * 0.6,
              color: primaryColor,
            ),
          ),
        Text(
          'Masuk',
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            fontFamily: 'Sora',
            color: textPrimaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Masukkan kredensial Anda untuk melanjutkan',
          style: TextStyle(
            fontSize: subtitleSize,
            fontFamily: 'Sora',
            color: textSecondaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isKeyboardVisible ? 15 : 30),
        // Username field with validation feedback
        TextField(
          controller: usernameController,
          onChanged: (_) => _validateUsername(),
          decoration: InputDecoration(
            labelText: 'Username',
            labelStyle: TextStyle(
              color: _usernameHasError 
                  ? errorColor 
                  : _usernameIsValid 
                      ? successColor 
                      : textSecondaryColor,
              fontFamily: 'Sora',
            ),
            prefixIcon: Icon(
              Icons.person,
              color: _usernameHasError 
                  ? errorColor 
                  : _usernameIsValid 
                      ? successColor 
                      : primaryColor,
            ),
            suffixIcon: _usernameController() ? null : (_usernameHasError || _usernameIsValid)
                ? Icon(
                    _usernameIsValid ? Icons.check_circle : Icons.error,
                    color: _usernameIsValid ? successColor : errorColor,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: _usernameHasError 
                    ? errorColor 
                    : _usernameIsValid 
                        ? successColor 
                        : primaryColor,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: _usernameHasError 
                    ? errorColor 
                    : _usernameIsValid 
                        ? successColor 
                        : primaryColor,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: _usernameHasError 
                    ? errorColor 
                    : _usernameIsValid 
                        ? successColor 
                        : Colors.grey[300]!,
                width: 1.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: errorColor, width: 1.0),
            ),
            errorText: _usernameHasError ? _usernameErrorText : null,
            filled: true,
            fillColor: Colors.grey[50],
          ),
          style: const TextStyle(fontFamily: 'Sora'),
        ),
        SizedBox(height: betweenFieldsPadding),
        // Password field with validation feedback
        TextField(
          controller: passwordController,
          obscureText: !_isPasswordVisible,
          onChanged: (_) => _validatePassword(),
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(
              color: _passwordHasError 
                  ? errorColor 
                  : _passwordIsValid 
                      ? successColor 
                      : textSecondaryColor,
              fontFamily: 'Sora',
            ),
            prefixIcon: Icon(
              Icons.lock,
              color: _passwordHasError 
                  ? errorColor 
                  : _passwordIsValid 
                      ? successColor 
                      : primaryColor,
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_passwordIsValid)
                  const Icon(
                    Icons.check_circle,
                    color: successColor,
                  )
                else if (_passwordHasError && passwordController.text.isNotEmpty)
                  const Icon(
                    Icons.error,
                    color: errorColor,
                  ),
                IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: primaryColor,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: _passwordHasError 
                    ? errorColor 
                    : _passwordIsValid 
                        ? successColor 
                        : primaryColor,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: _passwordHasError 
                    ? errorColor 
                    : _passwordIsValid 
                        ? successColor 
                        : primaryColor,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: _passwordHasError 
                    ? errorColor 
                    : _passwordIsValid 
                        ? successColor 
                        : Colors.grey[300]!,
                width: 1.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: errorColor, width: 1.0),
            ),
            errorText: _passwordHasError ? _passwordErrorText : null,
            filled: true,
            fillColor: Colors.grey[50],
          ),
          style: const TextStyle(fontFamily: 'Sora'),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Navigate to ForgotPasswordPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
              );
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
        // Fixed height instead of Spacer to prevent overflow
        SizedBox(height: isKeyboardVisible ? 15 : 30),
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
        SizedBox(height: isKeyboardVisible ? 10 : 20),
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
        SizedBox(height: isKeyboardVisible ? 10 : 20),
      ],
    );
  }
  
  // Helper function to check if username controller is empty
  bool _usernameController() {
    return usernameController.text.isEmpty;
  }
}