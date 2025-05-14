import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  Timer? _inactivityTimer;
  bool _hasUserSwiped = false;
  bool _isAnimating = false; // Flag to track animation state

  // Enhanced color scheme with improved contrast and harmony
  static const Color primaryColor = Color(0xFF5C8D3E);      // Darker green
  static const Color secondaryColor = Color(0xFF68BB59);    // Vibrant green
  static const Color accentColor = Color(0xFFFF8A1F);       // Vibrant orange
  static const Color accentLightColor = Color(0xFFFFA24D);  // Light orange
  static const Color backgroundLightColor = Color(0xFFFAFCF7);
  static const Color backgroundDarkColor = Color(0xFFF0F5EA);
  static const Color textPrimaryColor = Color(0xFF2A2A2A);
  static const Color textSecondaryColor = Color(0xFF5A5A5A);
  static const Color highlightColor = Color(0xFFFFB81E);    // Vibrant yellow
  static const double horizontalPadding = 24.0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      'title': 'Piket Sekolah Jadi Seru!',
      'desc': 'KridaSehat mengubah piket sekolah menjadi aktivitas menyenangkan dengan tantangan dan hadiah menarik!',
      'image': 'assets/board/board1.png',
      'icon': Icons.cleaning_services_rounded,
      'iconColor': primaryColor,
      'backgroundGradient': const [Color(0xFFEDF5E7), Color(0xFFECF2F9)],
    },
    {
      'title': 'Scan, Bersihkan, Menangkan!',
      'desc': 'Scan area setelah dibersihkan, matikan lampu & AC saat tidak digunakan, dan raih poin untuk kelasmu!',
      'image': 'assets/board/board2.png',
      'icon': Icons.qr_code_scanner,
      'iconColor': accentColor,
      'backgroundGradient': const [Color(0xFFFFF8ED), Color(0xFFFFF0E0)],
    },
    {
      'title': 'Jadilah Juara Kebersihan',
      'desc': 'Kumpulkan poin, dapatkan badge eksklusif, dan jadikan kelasmu sebagai kelas terbersih sekolah!',
      'image': 'assets/board/board3.png',
      'icon': Icons.emoji_events,
      'iconColor': secondaryColor,
      'backgroundGradient': const [Color(0xFFEEF7E9), Color(0xFFDFEFD8)],
    },
    {
      'title': 'Perubahan Dimulai Darimu',
      'desc': 'Bergabunglah dengan teman-teman untuk menciptakan lingkungan sekolah yang lebih bersih dan sehat untuk semua!',
      'image': 'assets/board/board4.png',
      'icon': Icons.groups,
      'iconColor': highlightColor,
      'backgroundGradient': const [Color(0xFFFFFAEC), Color(0xFFFFF4D6)],
    },
  ];

  @override
  void initState() {
    super.initState();
    // Set preferred orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    // Softer animations with gentler curves
    _fadeAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuad),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuad),
    );
    
    _rotateAnimation = Tween<double>(begin: 0.007, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuad),
    );

    // Start with initial animation
    _animationController.forward();
    _resetInactivityTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _inactivityTimer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 6), () {
      _autoAdvanceSlide();
    });
  }

  void _autoAdvanceSlide() {
    if (_isAnimating) return; // Prevent multiple animations

    if (_currentPage == onboardingData.length - 1) {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
      setState(() {
        _hasUserSwiped = false;
      });
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
      setState(() {
        _hasUserSwiped = true;
      });
    }
    
    // Gently reset animation without causing a flash
    _restartAnimation(gentleMode: true);
    _resetInactivityTimer();
  }

  // New method for more controlled animation restarting
  void _restartAnimation({bool gentleMode = false}) {
    setState(() {
      _isAnimating = true;
    });
    
    if (gentleMode) {
      // For gentle transitions, don't reset to 0, reset to a higher value
      _animationController.value = 0.6;
      _animationController.forward().then((_) {
        setState(() {
          _isAnimating = false;
        });
      });
    } else {
      // For normal transitions when explicitly requested by user
      _animationController.reset();
      _animationController.forward().then((_) {
        setState(() {
          _isAnimating = false;
        });
      });
    }
  }

  void _handleNextPress() {
    if (_isAnimating) return; // Prevent multiple animations
    
    _resetInactivityTimer();
    
    if (_currentPage == onboardingData.length - 1) {
      // Add haptic feedback
      HapticFeedback.mediumImpact();
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // Add haptic feedback
      HapticFeedback.lightImpact();
      
      setState(() {
        _isAnimating = true;
      });
      
      // First complete any current animation
      _animationController.forward().then((_) {
        // Then move to next page
        _pageController.nextPage(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
        
        setState(() {
          _hasUserSwiped = true;
        });
        
        // Use gentle animation restart to avoid flash
        _restartAnimation(gentleMode: true);
      });
    }
  }

  void _skipToEnd() {
    // Add haptic feedback
    HapticFeedback.mediumImpact();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    
    return GestureDetector(
      onTap: _resetInactivityTimer,
      onPanDown: (_) => _resetInactivityTimer(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                backgroundLightColor,
                backgroundDarkColor.withOpacity(0.5),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: onboardingData.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                        // Use gentle animation restart to avoid flash
                        _restartAnimation(gentleMode: true);
                        
                        if (index > 0) {
                          _hasUserSwiped = true;
                        }
                      });
                      
                      // Add haptic feedback
                      HapticFeedback.selectionClick();
                      _resetInactivityTimer();
                    },
                    itemBuilder: (context, index) =>
                        _buildPageContent(context, onboardingData[index]),
                  ),
                ),
                _buildFooter(screenHeight),
              ],
            ),
          ),
        ),
        floatingActionButton: _buildNextButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          _buildLogo(),
          const SizedBox(width: 12),
          const Text(
            'KridaSehat',
            style: TextStyle(
              fontFamily: 'Sora',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: primaryColor,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 300),
            child: _currentPage != onboardingData.length - 1
                ? TextButton(
                    onPressed: _skipToEnd,
                    style: TextButton.styleFrom(
                      foregroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lewati',
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: accentColor.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.skip_next, 
                          size: 16, 
                          color: accentColor.withOpacity(0.9),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: highlightColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Terakhir',
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: highlightColor,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.check_circle_outline, size: 16, color: highlightColor),
                      ],
                    ),
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
      child: Image.asset(
        'assets/images/logo.png',
        width: 28,
        height: 28,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.cleaning_services,
          color: primaryColor,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildPageContent(BuildContext context, Map<String, dynamic> data) {
    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundColor = data['backgroundGradient'] as List<Color>? ?? [Colors.white, backgroundLightColor];
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotateAnimation.value,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: screenHeight * 0.45,
                          ),
                          child: _buildImageContainer(
                            data['image']!,
                            data['icon'],
                            data['iconColor'],
                            backgroundColor,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildAnimatedTitle(data['title']!),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            data['desc']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Sora',
                              color: textSecondaryColor,
                              height: 1.4,
                            ),
                          ),
                        ),
                        if (_currentPage == 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: _buildGamificationPreview(),
                          ),
                        SizedBox(height: screenHeight * 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedTitle(String title) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          fontFamily: 'Sora',
          color: Colors.white,
          letterSpacing: 0.5,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildGamificationPreview() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildRewardItem('Bintang Kebersihan', Icons.star, highlightColor),
          _buildRewardItem('Peraih Poin', Icons.emoji_events, accentColor),
          _buildRewardItem('Badge Eksklusif', Icons.workspace_premium, secondaryColor),
        ],
      ),
    );
  }

  Widget _buildRewardItem(String label, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.15),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 90,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
              letterSpacing: 0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildImageContainer(
    String imagePath, 
    IconData fallbackIcon, 
    Color iconColor,
    List<Color> backgroundColors,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.12),
            blurRadius: 25,
            spreadRadius: 3,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            blurRadius: 20,
            spreadRadius: -5,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Outer frame with elevation effect
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  backgroundLightColor,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.08),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gradient background for the image
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: backgroundColors,
                        ),
                      ),
                    ),
                    // Actual image with enhanced error handling
                    Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          color: backgroundColors[0].withOpacity(0.8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              fallbackIcon,
                              size: 70,
                              color: iconColor,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                "Ilustrasi ${_currentPage + 1}",
                                style: const TextStyle(
                                  color: textPrimaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Overlay gradient for better text visibility
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.05),
                          ],
                          stops: const [0.7, 1.0],
                        ),
                      ),
                    ),
                    // Subtle pattern overlay for texture
                    Opacity(
                      opacity: 0.05,
                      child: Container(
                        decoration: const BoxDecoration(
                          backgroundBlendMode: BlendMode.overlay,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Swipe prompt
          if (!_hasUserSwiped)
            Positioned(
              bottom: 16,
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return AnimatedOpacity(
                    opacity: _hasUserSwiped ? 0.0 : value,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.swipe,
                            color: accentColor,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Geser untuk lanjut",
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFooter(double screenHeight) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24, 
        0, 
        24, 
        MediaQuery.of(context).padding.bottom + 20
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPageIndicator(),
          _buildAnimatedProgressText(),
        ],
      ),
    );
  }

  Widget _buildAnimatedProgressText() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.2, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        "${_currentPage + 1}/${onboardingData.length}",
        key: ValueKey<int>(_currentPage),
        style: TextStyle(
          color: textSecondaryColor.withOpacity(0.6),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return SizedBox(
      height: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
          onboardingData.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: _currentPage == index ? 30 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: _currentPage == index 
                    ? accentColor 
                    : (index < _currentPage 
                      ? accentColor.withOpacity(0.3) 
                      : Colors.grey[300]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: _currentPage == index
                    ? [
                        BoxShadow(
                          color: accentColor.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    final isLastPage = _currentPage == onboardingData.length - 1;
    
    return Hero(
      tag: 'nextButton',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 60,
        height: 60,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 20, 
          right: 8
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLastPage 
                ? const [highlightColor, accentColor] 
                : const [accentColor, accentLightColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: isLastPage
                  ? highlightColor.withOpacity(0.3)
                  : accentColor.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, 5),
            ),
            const BoxShadow(
            color: Colors.white,
            blurRadius: 12,
            spreadRadius: -3,
            offset: Offset(0, -4),
          ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleNextPress,
            splashColor: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(30),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: isLastPage
                    ? const Icon(
                        Icons.rocket_launch_rounded,
                        color: Colors.white,
                        size: 26,
                                                key: ValueKey('rocket'),
                      )
                    : const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 26,
                        key: ValueKey('arrow'),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}