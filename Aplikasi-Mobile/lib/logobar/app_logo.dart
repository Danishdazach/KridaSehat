import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? textColor;

  const AppLogo({
    Key? key,
    this.size = 42.0,
    this.showText = true,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define standard colors (same as in your onboarding screen)
    const Color primaryColor = Color(0xFF5C8D3E);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/images/logo.png',
            width: size,
            height: size,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.cleaning_services,
              color: primaryColor,
              size: size * 0.52, // Proportional to the container size
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 12),
          Text(
            'KridaSehat',
            style: TextStyle(
              fontFamily: 'Sora',
              fontWeight: FontWeight.bold,
              fontSize: size * 0.43, // Proportional to logo size
              color: textColor ?? primaryColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}