import 'package:flutter/material.dart';
// Import AppLogo widget
import 'package:kridasehat/logobar/app_logo.dart';
import '../widgets/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final classController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  
  // Animation controllers
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  Animation<double>? _slideAnimation;
  Animation<double>? _scaleAnimation;
  
  // Validation state variables - made final as suggested
  final Map<String, bool> _hasError = {
    'username': false,
    'password': false,
    'email': false,
    'name': false,
    'class': false,
  };
  
  final Map<String, bool> _isValid = {
    'username': false,
    'password': false,
    'email': false,
    'name': false,
    'class': false,
  };
  
  final Map<String, String> _errorText = {
    'username': '',
    'password': '',
    'email': '',
    'name': '',
    'class': '',
  };

  // Design colors matching login page
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
    
    // Initialize animation controller
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
    usernameController.addListener(() => _validateField('username'));
    passwordController.addListener(() => _validateField('password'));
    emailController.addListener(() => _validateField('email'));
    nameController.addListener(() => _validateField('name'));
    classController.addListener(() => _validateField('class'));
  }

  @override
  void dispose() {
    // Remove listeners
    usernameController.removeListener(() => _validateField('username'));
    passwordController.removeListener(() => _validateField('password'));
    emailController.removeListener(() => _validateField('email'));
    nameController.removeListener(() => _validateField('name'));
    classController.removeListener(() => _validateField('class'));
    
    // Dispose controllers
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    nameController.dispose();
    classController.dispose();
    
    // Dispose animation
    _animationController?.dispose();
    super.dispose();
  }
  
  void _validateField(String field) {
    if (!mounted) return;
    
    setState(() {
      switch (field) {
        case 'username':
          if (usernameController.text.isEmpty) {
            _hasError['username'] = true;
            _isValid['username'] = false;
            _errorText['username'] = 'Username tidak boleh kosong';
          } else if (usernameController.text.length < 3) {
            _hasError['username'] = true;
            _isValid['username'] = false;
            _errorText['username'] = 'Username minimal 3 karakter';
          } else {
            _hasError['username'] = false;
            _isValid['username'] = true;
            _errorText['username'] = '';
          }
          break;
          
        case 'password':
          if (passwordController.text.isEmpty) {
            _hasError['password'] = true;
            _isValid['password'] = false;
            _errorText['password'] = 'Password tidak boleh kosong';
          } else if (passwordController.text.length < 4) {
            _hasError['password'] = true;
            _isValid['password'] = false;
            _errorText['password'] = 'Password minimal 4 karakter';
          } else {
            _hasError['password'] = false;
            _isValid['password'] = true;
            _errorText['password'] = '';
          }
          break;
          
        case 'email':
          final emailRegEx = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (emailController.text.isEmpty) {
            _hasError['email'] = true;
            _isValid['email'] = false;
            _errorText['email'] = 'Email tidak boleh kosong';
          } else if (!emailRegEx.hasMatch(emailController.text)) {
            _hasError['email'] = true;
            _isValid['email'] = false;
            _errorText['email'] = 'Format email tidak valid';
          } else {
            _hasError['email'] = false;
            _isValid['email'] = true;
            _errorText['email'] = '';
          }
          break;
          
        case 'name':
          if (nameController.text.isEmpty) {
            _hasError['name'] = true;
            _isValid['name'] = false;
            _errorText['name'] = 'Nama tidak boleh kosong';
          } else if (nameController.text.length < 3) {
            _hasError['name'] = true;
            _isValid['name'] = false;
            _errorText['name'] = 'Nama minimal 3 karakter';
          } else {
            _hasError['name'] = false;
            _isValid['name'] = true;
            _errorText['name'] = '';
          }
          break;
          
        case 'class':
          if (classController.text.isEmpty) {
            _hasError['class'] = true;
            _isValid['class'] = false;
            _errorText['class'] = 'Kelas tidak boleh kosong';
          } else {
            _hasError['class'] = false;
            _isValid['class'] = true;
            _errorText['class'] = '';
          }
          break;
      }
    });
  }

  void _togglePasswordVisibility() {
    if (!mounted) return;
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _register() async {
    // Validate all fields
    _validateField('username');
    _validateField('password');
    _validateField('email');
    _validateField('name');
    _validateField('class');
    
    // Check if all fields are valid
    if (_hasError.values.contains(true) || _isValid.values.contains(false)) {
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
                'Mohon isi semua data dengan benar',
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
      return;
    }
    
    // Show loading state
    setState(() {
      _isLoading = true;
    });
    
    // Simulate registration process
    await Future.delayed(const Duration(seconds: 1));
    
    if (!mounted) return;
    
    setState(() {
      _isLoading = false;
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Pendaftaran berhasil! Silakan login',
              style: TextStyle(fontFamily: 'Sora'),
            ),
          ],
        ),
        backgroundColor: successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      ),
    );
    
    // Navigate back to login page
    if (!mounted) return;
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pop(context);
    }
  }
  
  void _showErrorAnimation() {
    // Shake animation for error feedback
    controller() async {
      for (var i = 0; i < 3; i++) {
        await Future.delayed(const Duration(milliseconds: 50));
        if (!mounted) return;
        setState(() {});
        
        await Future.delayed(const Duration(milliseconds: 50));
        if (!mounted) return;
        setState(() {});
      }
    }
    controller();
  }

  @override
  Widget build(BuildContext context) {
    // Check if animations are ready
    if (_animationController == null) {
      return const Scaffold(
        backgroundColor: Colors.white, // Background putih untuk loading
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Adjust spacing based on keyboard visibility and screen size
    final double topPadding = isKeyboardVisible ? 0 : screenHeight < 700 ? 10 : 20;
    final double betweenFieldsPadding = isKeyboardVisible ? 6 : 12;
    
    return Scaffold(
      backgroundColor: Colors.white, // Background putih untuk Scaffold
      body: Container(
        // Mengganti gradient dengan warna putih solid
        color: Colors.white,
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
                              child: _buildRegisterForm(
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
      color: Colors.white, // Background putih untuk header
      child: Row(
        children: [
          // Menggunakan AppLogo widget yang konsisten
          const AppLogo(),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: 'Kembali',
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRegisterForm({
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
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [textPrimaryColor, AppTheme.primaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            'Daftar Akun',
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
          'Isi data diri Anda untuk membuat akun baru',
          style: TextStyle(
            fontSize: subtitleSize,
            fontFamily: 'Sora',
            color: textSecondaryColor,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isKeyboardVisible ? 15 : 30),
        
        // Input fields with animation delay
        TweenAnimationBuilder(
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
            controller: nameController,
            isPassword: false,
            labelText: 'Nama Lengkap',
            prefixIcon: Icons.person_outline,
            hasError: _hasError['name']!,
            isValid: _isValid['name']!,
            errorText: _errorText['name']!,
          ),
        ),
        
        SizedBox(height: betweenFieldsPadding),
        
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 550),
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
            prefixIcon: Icons.alternate_email,
            hasError: _hasError['username']!,
            isValid: _isValid['username']!,
            errorText: _errorText['username']!,
          ),
        ),
        
        SizedBox(height: betweenFieldsPadding),
        
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
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
            controller: emailController,
            isPassword: false,
            labelText: 'Email',
            prefixIcon: Icons.email_outlined,
            hasError: _hasError['email']!,
            isValid: _isValid['email']!,
            errorText: _errorText['email']!,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        
        SizedBox(height: betweenFieldsPadding),
        
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 650),
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
            prefixIcon: Icons.lock_outline,
            hasError: _hasError['password']!,
            isValid: _isValid['password']!,
            errorText: _errorText['password']!,
          ),
        ),
        
        SizedBox(height: betweenFieldsPadding),
        
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 700),
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
            controller: classController,
            isPassword: false,
            labelText: 'Kelas',
            prefixIcon: Icons.school_outlined,
            hasError: _hasError['class']!,
            isValid: _isValid['class']!,
            errorText: _errorText['class']!,
            keyboardType: TextInputType.number,
          ),
        ),
        
        SizedBox(height: isKeyboardVisible ? 20 : 40),
        
        // Register button with animation
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: _buildRegisterButton(),
        ),
        
        SizedBox(height: isKeyboardVisible ? 15 : 30),
        
        // Login link with animation
        TweenAnimationBuilder(
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
                'Sudah punya akun? ',
                style: TextStyle(
                  fontFamily: 'Sora',
                  color: textSecondaryColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: buttonColor,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Masuk',
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
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withAlpha(20),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        keyboardType: keyboardType,
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
          hintText: isPassword ? 'Minimal 4 karakter' : 
                   labelText == 'Kelas' ? 'Contoh: 9' : 
                   labelText == 'Email' ? 'Contoh: anda@email.com' : 
                   'Minimal 3 karakter',
          hintStyle: TextStyle(
            color: textSecondaryColor.withAlpha(128),
            fontFamily: 'Sora',
            fontSize: 12,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: hasError 
                ? errorColor 
                : isValid 
                    ? successColor 
                    : AppTheme.primaryColor,
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
                        color: AppTheme.primaryColor,
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
                      : AppTheme.primaryColor,
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
                      : AppTheme.primaryColor,
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
        textInputAction: TextInputAction.next,
      ),
    );
  }
  
  Widget _buildRegisterButton() {
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
            color: buttonColor.withAlpha(102),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _register,
          splashColor: Colors.white.withAlpha(51),
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
                        'Daftar',
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
                        Icons.how_to_reg,
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