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

  const SplashScreen({
    super.key,
    this.logoAsset = 'assets/images/logo.png',
    this.appName = 'KridaSehat',
    this.createdBy = 'Dazach',
    this.primaryColor = const Color(0xFF6E7E40),
    this.textColor = const Color(0xFF6E7E40),
    this.animationDuration = const Duration(milliseconds: 3000), // diperpanjang
    this.splashDuration = const Duration(seconds: 5),            // diperpanjang
    this.nextRoute = '/boarding',
    this.logoSize = 150,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _textAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _subtitleFadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _subtitleSlideAnimation;

  @override
  void initState() {
    super.initState();

    _logoAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDuration.inMilliseconds),
    );

    _textAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDuration.inMilliseconds),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _logoRotateAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _subtitleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _subtitleSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _logoAnimationController.forward();

    Future.delayed(
      const Duration(milliseconds: 1000),
      () => _textAnimationController.forward(),
    );

    Timer(widget.splashDuration, () {
      Navigator.pushReplacementNamed(context, widget.nextRoute);
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              widget.primaryColor.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              AnimatedBuilder(
                animation: _logoAnimationController,
                builder: (context, child) {
                  return Center(
                    child: Transform.rotate(
                      angle: _logoRotateAnimation.value,
                      child: Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Container(
                          width: widget.logoSize,
                          height: widget.logoSize,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: widget.primaryColor.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            widget.logoAsset,
                            fit: BoxFit.contain,
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
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Sora',
                          color: widget.textColor,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: widget.primaryColor.withOpacity(0.3),
                              blurRadius: 2,
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
                    child: Text(
                      'v1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Sora',
                        color: widget.textColor.withOpacity(0.5),
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
                        child: Text(
                          'Dibuat oleh ${widget.createdBy}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Sora',
                            color: widget.textColor.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
