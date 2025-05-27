import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final String logoAsset;
  final String appName;
  final String createdBy;
  final Color primaryColor;
  final Color textColor;
  final Duration animationDuration;
  final Duration splashDuration;
  final String nextRoute;
  final double logoSize;
  final String appVersion;

  const SplashScreen({
    super.key,
    this.logoAsset =  'assets/images/logo.png',
    this.appName = 'KridaSehat',
    this.createdBy = 'Dazach',
    this.primaryColor = const Color(0xFF6E7E40),
    this.textColor = const Color(0xFF6E7E40),
    this.animationDuration = const Duration(milliseconds: 3000),
    this.splashDuration = const Duration(seconds: 5),
    this.nextRoute = '/login',
    this.logoSize = 150,
    this.appVersion = 'v1.0.0',
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _textAnimationController;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _subtitleFadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _subtitleSlideAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _circleAnimation;

  @override
  void initState() {
    super.initState();

    _logoAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDuration.inMilliseconds ~/ 2),
    );

    _textAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDuration.inMilliseconds ~/ 2),
    );

    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDuration.inMilliseconds),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _logoAnimationController, curve: Curves.elasticOut),
    );
    _logoRotateAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(parent: _logoAnimationController, curve: Curves.easeOut),
    );
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoAnimationController, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)),
    );

    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textAnimationController, curve: const Interval(0.0, 0.7, curve: Curves.easeIn)),
    );
    _titleSlideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _textAnimationController, curve: const Interval(0.0, 0.7, curve: Curves.easeOut)),
    );
    _subtitleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textAnimationController, curve: const Interval(0.3, 1.0, curve: Curves.easeIn)),
    );
    _subtitleSlideAnimation = Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _textAnimationController, curve: const Interval(0.3, 1.0, curve: Curves.easeOut)),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundAnimationController, curve: Curves.easeOut),
    );
    _circleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundAnimationController, curve: const Interval(0.2, 0.8, curve: Curves.easeInOut)),
    );

    _backgroundAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () => _logoAnimationController.forward());
    Future.delayed(const Duration(milliseconds: 1200), () => _textAnimationController.forward());

    Timer(widget.splashDuration, () {
      Navigator.pushReplacementNamed(context, widget.nextRoute);
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _textAnimationController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimationController,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color.lerp(Colors.white, widget.primaryColor.withAlpha(51), _backgroundAnimation.value)!,
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -50,
                  right: -50,
                  child: Transform.scale(
                    scale: _circleAnimation.value,
                    child: Opacity(
                      opacity: _circleAnimation.value * 0.5,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.primaryColor.withAlpha(51),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -80,
                  left: -30,
                  child: Transform.scale(
                    scale: _circleAnimation.value,
                    child: Opacity(
                      opacity: _circleAnimation.value * 0.6,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.primaryColor.withAlpha(77),
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      const Spacer(flex: 2),
                      AnimatedBuilder(
                        animation: _logoAnimationController,
                        builder: (context, child) {
                          return Center(
                            child: FadeTransition(
                              opacity: _logoOpacityAnimation,
                              child: Transform.rotate(
                                angle: _logoRotateAnimation.value,
                                child: Transform.scale(
                                  scale: _logoScaleAnimation.value,
                                  child: Container(
                                    width: widget.logoSize,
                                    height: widget.logoSize,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      widget.logoAsset,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      AnimatedBuilder(
                        animation: _textAnimationController,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _titleSlideAnimation,
                            child: FadeTransition(
                              opacity: _titleFadeAnimation,
                              child: Text(
                                widget.appName,
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sora',
                                  color: widget.textColor,
                                  letterSpacing: 1.5,
                                  shadows: [
                                    Shadow(
                                      color: widget.primaryColor.withAlpha(77),
                                      blurRadius: 3,
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      AnimatedBuilder(
                        animation: _textAnimationController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _subtitleFadeAnimation,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.primaryColor.withAlpha(026),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: widget.primaryColor.withAlpha(51),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                widget.appVersion,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w500,
                                  color: widget.textColor.withAlpha(179),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const Spacer(flex: 2),
                      AnimatedBuilder(
                        animation: _textAnimationController,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _subtitleSlideAnimation,
                            child: FadeTransition(
                              opacity: _subtitleFadeAnimation,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 24.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Dibuat oleh',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Sora',
                                        color: widget.textColor.withAlpha(152),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.createdBy,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Sora',
                                        color: widget.textColor.withAlpha(204),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(widget.primaryColor),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
