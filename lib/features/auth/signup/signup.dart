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
      final user = await _auth.createUserWithEmailAndPassword(email, password);

      if (user != null) {
        final pref = await SharedPreferences.getInstance();
        await pref.setString('email', email);
        await pref.setString('password', password);
        await pref.setBool('isLoggedIn', true);

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'fullName': fullName,
          'email': email,
          'profileImageUrl': '', 
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
                : "Error creating account: ${e.toString().replaceAll("Exception: ", "")}",
          ),
          backgroundColor: Colors.red,
        ),
      );
      log('$e');
    }
  }

  Future<void> _signUpWithGoogle(BuildContext context) async {
    try {
      final user = await _auth.signInWithGoogle();

      if (user != null) {
        final pref = await SharedPreferences.getInstance();
        await pref.setBool('isLoggedIn', true);
        await pref.setString('email', user.email ?? '');

        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
                'uid': user.uid,
                'fullName': user.displayName ?? 'Google User',
                'email': user.email,
                'profileImageUrl': user.photoURL ?? '',
                'createdAt': FieldValue.serverTimestamp(),
              });
        }

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Signed in with Google successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Google Sign-In failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorByTheme(
        context: context,
        colorClass: AppColors.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: getColorByTheme(
                  context: context,
                  colorClass: AppColors.textColor,
                ),
              ),
            ),
            SizedBox(height: 32),
            TextField(
              style: TextStyle(
                color: getColorByTheme(
                  context: context,
                  colorClass: AppColors.textColor,
                ),
              ),
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Enter fullname',
                hintText: 'Enter fullname',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF48319D), width: 2),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              style: TextStyle(
                color: getColorByTheme(
                  context: context,
                  colorClass: AppColors.textColor,
                ),
              ),
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter email',
                hintText: 'Enter email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF48319D), width: 2),
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
                  style: TextStyle(
                    color: getColorByTheme(
                      context: context,
                      colorClass: AppColors.textColor,
                    ),
                  ),
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
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xFF48319D),
                        width: 2,
                      ),
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
                  backgroundColor: Color(0xFF48319D),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _signUpWithGoogle(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: getColorByTheme(
                    context: context,
                    colorClass: AppColors.backgroundColor,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Color(0xFF48319D), width: 2),
                  ),
                  elevation: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Image.asset('assets/images/google_img.png'),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Sign Up With Google",
                      style: TextStyle(
                        color: getColorByTheme(
                          context: context,
                          colorClass: AppColors.textColor,
                        ),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Already have an account ?",
                    style: TextStyle(
                      fontSize: 16,
                      color: getColorByTheme(
                        context: context,
                        colorClass: AppColors.textColor,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: ' Login',
                    style: TextStyle(
                      color: Color(0xFF48319D),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
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
