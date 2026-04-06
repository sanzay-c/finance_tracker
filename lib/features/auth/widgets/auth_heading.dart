// ─── Auth Heading ─────────────────────────────────────────────────────────────
// Usage:
//   AuthHeading(title: 'Welcome\nBack', subtitle: 'Sign in to your account', textColor: textColor)
//   AuthHeading(title: 'Create\nAccount', subtitle: 'Sign up to start tracking your finances', textColor: textColor)

import 'package:flutter/material.dart';

class AuthHeading extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color textColor;

  const AuthHeading({
    super.key,
    required this.title,
    required this.subtitle,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: textColor,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 15,
            color: textColor.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}