
// ─── Auth Primary Button ──────────────────────────────────────────────────────
// Usage:
//   AuthButton(label: 'Sign In', onPressed: () => _loginUser(context))
//   AuthButton(label: 'Sign Up', onPressed: () => _signUp(context))

import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF48319D);

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}