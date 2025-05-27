import 'package:flutter/material.dart';
import '../widgets/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? textColor;

  const AppLogo({
    super.key,
    this.size = 42.0,
    this.showText = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {

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
              color: AppTheme.primaryColor,
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
              color: textColor ?? AppTheme.primaryColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}