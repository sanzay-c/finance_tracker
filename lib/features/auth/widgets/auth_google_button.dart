
// ─── Auth Google Button ───────────────────────────────────────────────────────
// Usage:
//   AuthGoogleButton(label: 'Continue with Google', onPressed: () => _loginWithGoogle(context))

import 'package:flutter/material.dart';

class AuthGoogleButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color textColor;

  const AuthGoogleButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: textColor.withValues(alpha: 0.15), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Image.asset('assets/images/google_img.png'),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}