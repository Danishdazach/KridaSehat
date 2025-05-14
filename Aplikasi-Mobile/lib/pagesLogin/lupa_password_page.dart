import 'package:flutter/material.dart';

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
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  Animation<double>? _slideAnimation;
  Animation<double>? _scaleAnimation;
  
  // Username validation state
  bool _usernameHasError = false;
  bool _usernameIsValid = false;
  String _usernameErrorText = '';

  // Design colors (matched with LoginPage)
  static const Color primaryColor = Color(0xFF6E7E40);
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
    
    // Add listener to controller for real-time validation
    usernameController.addListener(_validateUsername);
  }

  @override
  void dispose() {
    usernameController.removeListener(_validateUsername);
    usernameController.dispose();
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

  void _resetPassword() async {
    _validateUsername();
    
    if (!_usernameHasError) {
      FocusScope.of(context).unfocus(); // Tutup keyboard

      setState(() {
        _isLoading = true;
      });

      // Simulate network request
      await Future.delayed(const Duration(seconds: 2));
      String username = usernameController.text;

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                'Link reset password telah dikirim ke $username',
                style: const TextStyle(fontFamily: 'Sora'),
              ),
            ],
          ),
          backgroundColor: successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );

      // Reset field and navigate back after successful reset
      usernameController.clear();
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if animations are ready
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
    final double topPadding = isKeyboardVisible ? 10 : screenHeight < 700 ? 20 : 30;
  
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 8),
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
            icon: const Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Kembali',
          ),
        ),
        title: Text(
          'Lupa Password',
          style: TextStyle(
            fontFamily: 'Sora', 
            fontWeight: FontWeight.bold,
            color: isKeyboardVisible ? primaryColor : Colors.transparent,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
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
              const SizedBox(height: 10),
              _buildHeader(isKeyboardVisible),
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
  
  Widget _buildHeader(bool isKeyboardVisible) {
    if (isKeyboardVisible) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
            child: Image.asset(
              'assets/images/logo.png',
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.rocket_launch,
                color: primaryColor,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'KridaSehat',
            style: TextStyle(
              fontFamily: 'Sora',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor,
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
    // Adjust text size based on keyboard visibility
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
                    Icons.lock_reset,
                    size: logoSize * 0.5,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            
          // Title with gradient
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [textPrimaryColor, primaryColor],
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
            color: primaryColor.withOpacity(0.08),
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
                    : primaryColor,
          ),
          suffixIcon: (usernameController.text.isEmpty ? null : (_usernameHasError || _usernameIsValid)
              ? Icon(
                  _usernameIsValid ? Icons.check_circle : Icons.error,
                  color: _usernameIsValid ? successColor : errorColor,
                  size: 18,
                )
              : null),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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