import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/core/global_data/global_theme/bloc/theme_bloc.dart';
import 'package:finance_tracker/features/auth/signup/signup.dart';
import 'package:finance_tracker/features/auth/services/auth_service.dart';
import 'package:finance_tracker/features/auth/widgets/auth_button.dart';
import 'package:finance_tracker/features/auth/widgets/auth_google_button.dart';
import 'package:finance_tracker/features/auth/widgets/auth_heading.dart';
import 'package:finance_tracker/features/auth/widgets/auth_textfield.dart';
import 'package:finance_tracker/features/bottom_nav_bar/presentation/bottom_nav_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _obscureTextNotifier = ValueNotifier(true);
  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _obscureTextNotifier.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLoggedIn') ?? false) {
      log('User already logged in');
      _navigateToHome();
    }
  }

  Future<void> _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please enter both email and password', isError: true);
      return;
    }

    try {
      final user =
          await _auth.loginUserWithEmailAndPassword(email, password);
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', email);
        _showSnackBar('Login successful!', isError: false);
        _navigateToHome();
      } else {
        _showSnackBar('Incorrect email or password.', isError: true);
      }
    } catch (e) {
      _showSnackBar(
          e.toString().replaceAll('Exception: ', ''), isError: true);
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final user = await _auth.signInWithGoogle();
      if (user != null) {
        final pref = await SharedPreferences.getInstance();
        await pref.setBool('isLoggedIn', true);
        await pref.setString('userEmail', user.email ?? '');

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

        _showSnackBar('Login with Google successful!', isError: false);
        _navigateToHome();
      }
    } catch (e) {
      _showSnackBar('Google Sign-In failed: $e', isError: true);
    }
  }

  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => BottomNavBar()),
      (route) => false,
    );
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
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: _ThemeToggle(),
                ),
              ),

              const SizedBox(height: 24),

              AuthHeading(
                title: 'Welcome\nBack',
                subtitle: 'Sign in to your account',
                textColor: textColor,
              ),

              const SizedBox(height: 40),

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

              AuthButton(label: 'Sign In', onPressed: _loginUser),

              const SizedBox(height: 14),

              AuthGoogleButton(
                label: 'Continue with Google',
                onPressed: _loginWithGoogle,
                textColor: textColor,
              ),

              const SizedBox(height: 28),

              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account?  ",
                        style: TextStyle(
                          fontSize: 15,
                          color: textColor.withValues(alpha: 0.5),
                        ),
                      ),
                      TextSpan(
                        text: 'Sign Up',
                        style: const TextStyle(
                          color: Color(0xFF48319D),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SignUpScreen()),
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


class _ThemeToggle extends StatefulWidget {
  @override
  _ThemeToggleState createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<_ThemeToggle> {
  bool _isDark = false;
  Color kPrimaryColor = Color(0xFF48319D);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _isDark = !_isDark);
        context.read<ThemeBloc>().add(ToggleThemeEvent());
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 50,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color:
              _isDark ? kPrimaryColor : Colors.grey.withValues(alpha: 0.25),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          alignment:
              _isDark ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isDark
                  ? Icons.nights_stay_rounded
                  : Icons.wb_sunny_rounded,
              size: 13,
              color: _isDark ? kPrimaryColor : Colors.orange,
            ),
          ),
        ),
      ),
    );
  }
}