import 'package:flutter/material.dart';
// Import AppLogo widget
import 'package:kridasehat/logobar/app_logo.dart';
import '../widgets/app_theme.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  bool _isLoading = false;
  
  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
  // Username validation state
  bool _usernameHasError = false;
  bool _usernameIsValid = false;
  String _usernameErrorText = '';

  // Design colors (matched with LoginPage)
  static const Color buttonColor = Color(0xFFFC7F07);
  static const Color buttonSecondaryColor = Color(0xFFFD9C3B);
  static const Color textPrimaryColor = Color(0xFF333333);
  static const Color textSecondaryColor = Color(0xFF666666);
  static const Color errorColor = Colors.redAccent;
  static const Color successColor = Color(0xFF4CAF50);

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuad),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // Start animations
    _animationController.forward();
    
    // Add listener to controller for real-time validation
    usernameController.addListener(_validateUsername);
  }

  @override
  void dispose() {
    usernameController.removeListener(_validateUsername);
    usernameController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  // Username validation logic
  void _validateUsername() {
    if (!mounted) return;
    
    setState(() {
      final username = usernameController.text.trim();
      if (username.isEmpty) {
        _usernameHasError = true;
        _usernameIsValid = false;
        _usernameErrorText = 'Username tidak boleh kosong';
      } else if (username.length < 3) {
        _usernameHasError = true;
        _usernameIsValid = false;
        _usernameErrorText = 'Username minimal 3 karakter';
      } else if (username.length > 50) {
        _usernameHasError = true;
        _usernameIsValid = false;
        _usernameErrorText = 'Username maksimal 50 karakter';
      } else if (!RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(username)) {
        _usernameHasError = true;
        _usernameIsValid = false;
        _usernameErrorText = 'Username hanya boleh mengandung huruf, angka, titik, underscore, dan dash';
      } else {
        _usernameHasError = false;
        _usernameIsValid = true;
        _usernameErrorText = '';
      }
    });
  }

  Future<void> _resetPassword() async {
    // Validate before proceeding
    _validateUsername();
    
    if (_usernameHasError) {
      return;
    }

    // Close keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network request
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      
      final String username = usernameController.text.trim();

      setState(() {
        _isLoading = false;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Link reset password telah dikirim ke email yang terdaftar untuk username: $username',
                    style: const TextStyle(fontFamily: 'Sora'),
                  ),
                ),
              ],
            ),
            backgroundColor: successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 4),
          ),
        );

        // Reset field and navigate back after successful reset
        usernameController.clear();
        
        // Navigate back after delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Terjadi kesalahan. Silakan coba lagi.',
                    style: TextStyle(fontFamily: 'Sora'),
                  ),
                ),
              ],
            ),
            backgroundColor: errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Adjust spacing based on keyboard visibility and screen size
    final double logoSize = isKeyboardVisible ? 60 : screenHeight < 700 ? 80 : 100;
    final double topPadding = isKeyboardVisible ? 10 : screenHeight < 700 ? 20 : 30;
  
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: _buildResetForm(
                                logoSize: logoSize,
                                topPadding: topPadding,
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
      color: Colors.white,
      child: Row(
        children: [
          const AppLogo(),
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
              icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Kembali',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetForm({
    required double logoSize,
    required double topPadding,
    required bool isKeyboardVisible,
  }) {
    final double titleSize = isKeyboardVisible ? 22 : 28;
    final double subtitleSize = isKeyboardVisible ? 13 : 16;
    
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: topPadding),
          
          // Logo icon
          if (!isKeyboardVisible || logoSize > 0)
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.5, end: 1.0),
              duration: const Duration(milliseconds: 600),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Center(
                child: Container(
                  height: logoSize,
                  width: logoSize,
                  margin: EdgeInsets.only(bottom: isKeyboardVisible ? 5 : 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.15),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.lock_reset,
                    size: logoSize * 0.6,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ),
            
          // Title with gradient
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [textPrimaryColor, AppTheme.primaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              'Reset Password',
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
          
          // Subtitle
          Text(
            'Masukkan username Anda untuk menerima link reset password melalui email yang terdaftar.',
            style: TextStyle(
              fontSize: subtitleSize,
              fontFamily: 'Sora',
              color: textSecondaryColor,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isKeyboardVisible ? 20 : 40),
          
          // Username field with animation
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
            child: _buildInputField(),
          ),
          
          SizedBox(height: isKeyboardVisible ? 30 : 50),
          
          // Reset button with animation
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: _buildResetButton(),
          ),
          
          SizedBox(height: isKeyboardVisible ? 15 : 30),
          
          // Back to login button with animation
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
            child: Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Kembali ke Halaman Login',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          SizedBox(height: isKeyboardVisible ? 10 : 20),
        ],
      ),
    );
  }
  
  Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: usernameController,
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
          hintText: 'Masukkan username Anda',
          hintStyle: TextStyle(
            color: textSecondaryColor.withOpacity(0.5),
            fontFamily: 'Sora',
            fontSize: 12,
          ),
          prefixIcon: Icon(
            Icons.person,
            color: _usernameHasError 
                ? errorColor 
                : _usernameIsValid 
                    ? successColor 
                    : AppTheme.primaryColor,
          ),
          suffixIcon: usernameController.text.isNotEmpty && (_usernameHasError || _usernameIsValid)
              ? Icon(
                  _usernameIsValid ? Icons.check_circle : Icons.error,
                  color: _usernameIsValid ? successColor : errorColor,
                  size: 18,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: _usernameHasError 
                  ? errorColor 
                  : _usernameIsValid 
                      ? successColor 
                      : AppTheme.primaryColor,
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
                      : AppTheme.primaryColor,
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
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _resetPassword(),
        textCapitalization: TextCapitalization.none,
        autocorrect: false,
      ),
    );
  }
  
  Widget _buildResetButton() {
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
          onTap: _isLoading ? null : _resetPassword,
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
                        'Kirim Link Reset',
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
                        Icons.send_rounded,
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