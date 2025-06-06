import 'package:finance_tracker/helper/auth/auth_service.dart';
import 'package:flutter/material.dart';

class AuthUtils {
  static final AuthService _auth = AuthService();

  //Call this in login button with proper controllers passed
  static Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both required fields")),
      );
      return;
    }

    try {
      final user = await _auth.loginUserWithEmailAndPassword(email, password);
      if (user != null && context.mounted) {
        Navigator.pushNamed(context, "/home");
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed:$e")));
    }
  }

  static Future<void> signup({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
  }) async {
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter all the required fields")),
      );
      return;
    }

    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email.trim(),
        password.trim(),
      );
      if (user != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("User Created Successfully!")));
        Navigator.pushNamed(context, "/");
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Signup failed:$e")));
    }
  }
}
