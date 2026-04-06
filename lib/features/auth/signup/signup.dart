import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/features/auth/login/login.dart';
import 'package:finance_tracker/features/auth/services/auth_service.dart';
import 'package:finance_tracker/features/auth/widgets/auth_button.dart';
import 'package:finance_tracker/features/auth/widgets/auth_google_button.dart';
import 'package:finance_tracker/features/auth/widgets/auth_heading.dart';
import 'package:finance_tracker/features/auth/widgets/auth_textfield.dart';
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
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _obscureTextNotifier = ValueNotifier(true);
  final _auth = AuthService();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _obscureTextNotifier.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill all the fields.', isError: true);
      return;
    }

    try {
      final user =
          await _auth.createUserWithEmailAndPassword(email, password);

      if (user != null) {
        final pref = await SharedPreferences.getInstance();
        await pref.setString('email', email);
        await pref.setString('password', password);
        await pref.setBool('isLoggedIn', true);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'uid': user.uid,
          'fullName': fullName,
          'email': email,
          'profileImageUrl': '',
          'createdAt': FieldValue.serverTimestamp(),
        });

        _showSnackBar('Account created successfully!', isError: false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => BottomNavBar()),
        );
      }
    } catch (e) {
      _showSnackBar(
        e.toString().contains('already in use')
            ? 'Email already in use. Please use a different email.'
            : 'Error creating account: ${e.toString().replaceAll("Exception: ", "")}',
        isError: true,
      );
      log('$e');
    }
  }

  Future<void> _signUpWithGoogle() async {
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

        _showSnackBar('Signed in with Google successfully!', isError: false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const BottomNavBar()),
          (route) => false,
        );
      }
    } catch (e) {
      _showSnackBar('Google Sign-In failed: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(message,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            isError ? Colors.red.shade700 : Colors.green.shade700,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = getColorByTheme(
        context: context, colorClass: AppColors.backgroundColor);
    final textColor = getColorByTheme(
        context: context, colorClass: AppColors.textColor);
    final isDark = bgColor.computeLuminance() < 0.5;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),

              AuthHeading(
                title: 'Create\nAccount',
                subtitle: 'Sign up to start tracking your finances',
                textColor: textColor,
              ),

              const SizedBox(height: 40),

              AuthTextField(
                controller: _fullNameController,
                label: 'Full Name',
                hint: 'Your Name',
                prefixIcon: Icons.person_outline_rounded,
                textColor: textColor,
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              AuthTextField(
                controller: _emailController,
                label: 'Email Address',
                hint: 'you@example.com',
                prefixIcon: Icons.mail_outline_rounded,
                textColor: textColor,
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              ValueListenableBuilder<bool>(
                valueListenable: _obscureTextNotifier,
                builder: (context, obscure, _) {
                  return AuthTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: '••••••••',
                    prefixIcon: Icons.lock_outline_rounded,
                    textColor: textColor,
                    isDark: isDark,
                    obscureText: obscure,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: textColor.withValues(alpha: 0.4),
                        size: 20,
                      ),
                      onPressed: () => _obscureTextNotifier.value =
                          !_obscureTextNotifier.value,
                    ),
                  );
                },
              ),

              const SizedBox(height: 36),

              AuthButton(label: 'Sign Up', onPressed: _signUp),

              const SizedBox(height: 14),

              AuthGoogleButton(
                label: 'Continue with Google',
                onPressed: _signUpWithGoogle,
                textColor: textColor,
              ),

              const SizedBox(height: 28),

              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account?  ',
                        style: TextStyle(
                          fontSize: 15,
                          color: textColor.withValues(alpha: 0.5),
                        ),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Color(0xFF48319D),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => LoginScreen()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}