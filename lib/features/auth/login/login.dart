import 'dart:developer';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/core/global_data/global_theme/bloc/theme_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finance_tracker/features/auth/services/auth_service.dart';
import 'package:finance_tracker/features/auth/signup/signup.dart';
import 'package:finance_tracker/features/bottom_nav_bar/presentation/bottom_nav_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  ValueNotifier<bool> obscureTextNotifier = ValueNotifier<bool>(true);

  final _auth = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    obscureTextNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  /// Automatically navigate to BottomNavBar if already logged in
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      log("User already logged in");
      _navigateToHome();
    }
  }

  Future<void> _loginUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final enteredEmail = _emailController.text.trim();
    final enteredPassword = _passwordController.text.trim();

    if (enteredEmail.isEmpty || enteredPassword.isEmpty) {
      _showSnackBar("Please enter both email and password", isError: true);
      return;
    }

    final user = await _auth.loginUserWithEmailAndPassword(
      enteredEmail,
      enteredPassword,
    );

    if (user != null) {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', enteredEmail); // Save session info

      _showSnackBar("Login successful!", isError: false);
      _navigateToHome();
    } else {
      _showSnackBar("Incorrect email or password.", isError: true);
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => BottomNavBar()),
    );
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
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
            Positioned(child: DarkModeSwitch()),
            Text(
              'Login',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: getColorByTheme(context: context, colorClass: AppColors.textColor)),
            ),
            SizedBox(height: 32),
            TextField(
              style: TextStyle(color: getColorByTheme(context: context, colorClass: AppColors.textColor)),
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter email',
                hintText: 'Enter email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
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
              style: TextStyle(color: getColorByTheme(context: context, colorClass: AppColors.textColor)),
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
                      borderSide: BorderSide(
                        color: Colors.pinkAccent,
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
                onPressed: () => _loginUser(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Color(0xFF48319D),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(fontSize: 16, color: getColorByTheme(context: context, colorClass: AppColors.textColor)),
                  ),
                  TextSpan(
                    text: 'Signup',
                    style: TextStyle(
                      color:  Color(0xFF48319D),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => SignUpScreen()),
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

class DarkModeSwitch extends StatefulWidget {
  const DarkModeSwitch({super.key});

  @override
  _DarkModeSwitchState createState() => _DarkModeSwitchState();
}

class _DarkModeSwitchState extends State<DarkModeSwitch> {
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          setState(() {
            _isDarkTheme = !_isDarkTheme;
          });
    
          context.read<ThemeBloc>().add(ToggleThemeEvent());
        },
        child: Icon(
          size: 32,
          _isDarkTheme ? Icons.nights_stay : Icons.wb_sunny,
          color:
              _isDarkTheme
                  ? const Color.fromARGB(255, 170, 214, 235)
                  : Colors.orange,
        ),
      ),
    );
  }
}
