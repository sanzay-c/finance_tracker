import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/features/auth/login/login.dart';
import 'package:finance_tracker/features/auth/services/auth_service.dart';
import 'package:finance_tracker/features/bottom_nav_bar/presentation/bottom_nav_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = AuthService();
  final ValueNotifier<bool> obscureTextNotifier = ValueNotifier(true);

  Future<void> _signUp(BuildContext context) async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Please fill all the fields."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Create user in Firebase Auth
      final user = await _auth.createUserWithEmailAndPassword(email, password);

      if (user != null) {
        // Store credentials locally (for auto-login)
        final pref = await SharedPreferences.getInstance();
        await pref.setString('email', email);
        await pref.setString('password', password);
        await pref.setBool('isLoggedIn', true);

        // Create user document in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'fullName': fullName,
          'email': email,
          'profileImageUrl': '', // Default or empty for now
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Account created successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            e.toString().contains('already in use')
                ? "Email already in use. Please use a different email."
                : "Error creating account: ${e.toString()}",
          ),
          backgroundColor: Colors.red,
        ),
      );
      log('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorByTheme(context: context, colorClass: AppColors.backgroundColor),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign Up',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Enter fullname',
                hintText: 'Enter fullname',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter email',
                hintText: 'Enter email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
                ),
              ),
            ),
            SizedBox(height: 16),
            ValueListenableBuilder<bool>(
              valueListenable: obscureTextNotifier,
              builder: (context, obscureText, child) {
                return TextField(
                  controller: _passwordController,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    labelText: 'Enter password',
                    hintText: 'Enter password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        obscureTextNotifier.value = !obscureTextNotifier.value;
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _signUp(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Already have an account ?",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextSpan(
                    text: ' Login',
                    style: TextStyle(
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
