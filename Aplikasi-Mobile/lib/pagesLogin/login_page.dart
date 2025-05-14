import 'package:flutter/material.dart';
import 'package:kridasehat/pagesLogin/daftar_page.dart';
import 'package:kridasehat/pagesLogin/lupa_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  
  // Important fix: Initialize animation controllers with default values
  // instead of using 'late'
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  Animation<double>? _slideAnimation;
  Animation<double>? _scaleAnimation;
  
  // Validation state variables
  bool _usernameHasError = false;
  bool _passwordHasError = false;
  bool _usernameIsValid = false;
  bool _passwordIsValid = false;
  String _usernameErrorText = '';
  String _passwordErrorText = '';
  bool _isLoading = false;

  // Updated design colors
  static const Color primaryColor = Color(0xFF6E7E40);
  static const Color buttonColor = Color(0xFFFC7F07);
  static const Color buttonSecondaryColor = Color(0xFFFD9C3B);
  static const Color textPrimaryColor = Color(0xFF333333);
  static const Color textSecondaryColor = Color(0xFF666666);
  static const Color errorColor = Colors.redAccent;
  static const Color successColor = Color(0xFF4CAF50);
  static const double horizontalPadding = 24.0;

  @override
  void initState() {
    super.initState();
    
    // Fix: Initialize animation controller safely
    try {
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );

      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.easeIn),
      );

      _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.easeOutQuad),
      );

      _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.easeOutBack),
      );

      _animationController!.forward();
    } catch (e) {
      // Handle initialization error
      debugPrint('Animation controller initialization error: $e');
    }
    
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
    
    // Fix: Safe disposal
    _animationController?.dispose();
    super.dispose();
  }
  
  // Username validation logic
  void _validateUsername() {
    if (!mounted) return;
    
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
    if (!mounted) return;
    
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

  Future<void> _login() async {
    // Force validation before login attempt
    _validateUsername();
    _validatePassword();
    
    // Only proceed if both fields are valid
    if (!_usernameHasError && !_passwordHasError) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Properly check if the widget is still mounted before updating state
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });
      
      String username = usernameController.text;
      String password = passwordController.text;

      // Check for admin login
      if (username == 'admin' && password == '1234') {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/landing', arguments: {
          'userType': 'admin',
          'username': username,
        });
      } 
      // Check for student login
      else if (_isValidStudentAccount(username, password)) {
        Map<String, dynamic> studentData = _getStudentData(username);
        
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/landing', arguments: {
          'userType': 'student',
          'username': username,
          'studentData': studentData,
        });
      } 
      else {
        // Show error animation
        _showErrorAnimation();
        
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Username atau password salah',
                  style: TextStyle(fontFamily: 'Sora'),
                ),
              ],
            ),
            backgroundColor: errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(12),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showErrorAnimation() {
    // Shake animation for error feedback
    
    controller() async {
      for (var i = 0; i < 3; i++) {
        await Future.delayed(const Duration(milliseconds: 50));
        if (!mounted) return;
        setState(() => usernameController.text.isEmpty ? 
          passwordController.value = passwordController.value.copyWith(
            text: passwordController.text,
            selection: passwordController.selection,
          ) : 
          usernameController.value = usernameController.value.copyWith(
            text: usernameController.text,
            selection: usernameController.selection,
          ));
        
        await Future.delayed(const Duration(milliseconds: 50));
        if (!mounted) return;
        setState(() => usernameController.text.isEmpty ? 
          passwordController.value = passwordController.value.copyWith(
            text: passwordController.text,
            selection: passwordController.selection,
          ) : 
          usernameController.value = usernameController.value.copyWith(
            text: usernameController.text,
            selection: usernameController.selection,
          ));
      }
      
      // Clear the fields after shaking
      if (!mounted) return;
      if (usernameController.text.isNotEmpty) {
        usernameController.clear();
      }
      passwordController.clear();
      
      setState(() {
        _usernameHasError = false;
        _passwordHasError = false;
        _usernameIsValid = false;
        _passwordIsValid = false;
        _usernameErrorText = '';
        _passwordErrorText = '';
      });
    }
    
    controller();
  }

  // Student account validation
  final Map<String, Map<String, dynamic>> _studentAccounts = {
    'student1': {
      'password': 'password1',
      'nama': 'Siswa Pertama',
      'kelas': '9',
      'email': 'student1@example.com',
      'points': 120,
    },
    'student2': {
      'password': 'password2',
      'nama': 'Siswa Kedua', 
      'kelas': '8',
      'email': 'student2@example.com',
      'points': 85,
    },
  };

  bool _isValidStudentAccount(String username, String password) {
    return _studentAccounts.containsKey(username) && 
           _studentAccounts[username]!['password'] == password;
  }

  Map<String, dynamic> _getStudentData(String username) {
    final userData = Map<String, dynamic>.from(_studentAccounts[username]!);
    userData.remove('password');
    return userData;
  }

  void _togglePasswordVisibility() {
    if (!mounted) return;
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fix: Check if animations are ready
    if (_animationController == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Adjust spacing based on keyboard visibility and screen size
    final double logoSize = isKeyboardVisible ? 60 : screenHeight < 700 ? 80 : 100;
    final double topPadding = isKeyboardVisible ? 5 : screenHeight < 700 ? 20 : 30;
    final double betweenFieldsPadding = isKeyboardVisible ? 8 : 16;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              const Color(0xFFF8F9F2),
              const Color(0xFFF1F4E8),
              primaryColor.withOpacity(0.1),
            ],
            stops: const [0.0, 0.4, 0.8, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: AnimatedBuilder(
                    animation: _animationController!,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation!,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation!.value),
                          child: Transform.scale(
                            scale: _scaleAnimation!.value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                              child: _buildLoginForm(
                                logoSize: logoSize,
                                topPadding: topPadding, 
                                betweenFieldsPadding: betweenFieldsPadding,
                                isKeyboardVisible: isKeyboardVisible
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _buildLogo(),
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
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: primaryColor),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/boarding');
              },
              tooltip: 'Kembali',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Hero(
        tag: 'app_logo',
        child: Image.asset(
          'assets/images/logo.png',
          width: 32,
          height: 32,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.rocket_launch,
            color: primaryColor,
            size: 24,
          ),
        ),
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
          Center(
            child: Container(
              height: logoSize,
              width: logoSize,
              margin: EdgeInsets.only(bottom: isKeyboardVisible ? 5 : 20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.15),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.person_outline,
                size: logoSize * 0.6,
                color: primaryColor,
              ),
            ),
          ),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [textPrimaryColor, primaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            'Masuk',
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'Sora',
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Masukkan kredensial Anda untuk melanjutkan',
          style: TextStyle(
            fontSize: subtitleSize,
            fontFamily: 'Sora',
            color: textSecondaryColor,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isKeyboardVisible ? 15 : 30),
        
        // Username field with animation
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: _buildInputField(
            controller: usernameController,
            isPassword: false,
            labelText: 'Username',
            prefixIcon: Icons.person,
            hasError: _usernameHasError,
            isValid: _usernameIsValid,
            errorText: _usernameErrorText,
          ),
        ),
        
        SizedBox(height: betweenFieldsPadding),
        
        // Password field with animation
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: _buildInputField(
            controller: passwordController,
            isPassword: true,
            labelText: 'Password',
            prefixIcon: Icons.lock,
            hasError: _passwordHasError,
            isValid: _passwordIsValid,
            errorText: _passwordErrorText,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Forgot password with animation
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: child,
            );
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: buttonColor,
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Lupa Password?',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        
        SizedBox(height: isKeyboardVisible ? 20 : 40),
        
        // Login button with animation
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: _buildLoginButton(),
        ),
        
        SizedBox(height: isKeyboardVisible ? 15 : 30),
        
        // Register link with animation
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: child,
            );
          },
          child: Row(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: buttonColor,
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
        ),
        
        SizedBox(height: isKeyboardVisible ? 10 : 20),
      ],
    );
  }
  
  Widget _buildInputField({
    required TextEditingController controller,
    required bool isPassword,
    required String labelText,
    required IconData prefixIcon,
    required bool hasError,
    required bool isValid,
    required String errorText,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        onChanged: (_) => isPassword ? _validatePassword() : _validateUsername(),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: hasError 
                ? errorColor 
                : isValid 
                    ? successColor 
                    : textSecondaryColor,
            fontFamily: 'Sora',
          ),
          hintText: isPassword ? 'Minimal 4 karakter' : 'Minimal 3 karakter',
          hintStyle: TextStyle(
            color: textSecondaryColor.withOpacity(0.5),
            fontFamily: 'Sora',
            fontSize: 12,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: hasError 
                ? errorColor 
                : isValid 
                    ? successColor 
                    : primaryColor,
          ),
          suffixIcon: isPassword
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isValid)
                      const Icon(
                        Icons.check_circle,
                        color: successColor,
                        size: 18,
                      )
                    else if (hasError && controller.text.isNotEmpty)
                      const Icon(
                        Icons.error,
                        color: errorColor,
                        size: 18,
                      ),
                    IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        color: primaryColor,
                        size: 22,
                      ),
                      onPressed: _togglePasswordVisibility,
                      splashRadius: 20,
                    ),
                  ],
                )
              : (controller.text.isEmpty ? null : (hasError || isValid)
                  ? Icon(
                      isValid ? Icons.check_circle : Icons.error,
                      color: isValid ? successColor : errorColor,
                      size: 18,
                    )
                  : null),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: hasError 
                  ? errorColor 
                  : isValid 
                      ? successColor 
                      : primaryColor,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: hasError 
                  ? errorColor 
                  : isValid 
                      ? successColor 
                      : primaryColor,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: hasError 
                  ? errorColor 
                  : isValid 
                      ? successColor 
                      : Colors.grey[300]!,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: errorColor, width: 1.0),
          ),
          errorText: hasError ? errorText : null,
          errorStyle: const TextStyle(
            fontFamily: 'Sora',
            fontSize: 12,
            height: 0.8,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(
          fontFamily: 'Sora',
          fontSize: 15,
        ),
        keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.text,
        textInputAction: isPassword ? TextInputAction.done : TextInputAction.next,
        onSubmitted: isPassword ? (_) => _login() : null,
      ),
    );
  }
  
  Widget _buildLoginButton() {
    return Container(
      width: 200,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [buttonColor, buttonSecondaryColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _login,
          splashColor: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.login_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}