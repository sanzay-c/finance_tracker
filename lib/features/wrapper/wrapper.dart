import 'dart:developer';
import 'package:finance_tracker/features/home/presentation/screens/homepage_screen.dart';
import 'package:finance_tracker/features/login/presentation/screens/login_screen.dart';
import 'package:finance_tracker/features/onboardings/presentation/screens/onboarding_screen.dart';
import 'package:finance_tracker/features/splash/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  // final bool _showSplash = true;
  bool _showOnboarding = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    // if (_showSplash) {
    //   return const SplashScreen();
    // }

    if (!_initialized) {
      return const Center(child: SplashScreen());
    }

    if (_showOnboarding) {
      return OnboardingScreen(
        onFinish: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('hasSeenOnboarding', true);
          setState(() {
            _showOnboarding = false;
          });
        },
      );
    }
    //show login/homepage based on status
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error Loading App"));
          } else {
            if (snapshot.data == null) {
              log("login ma aayo"); //user not logged in
              return LoginScreen();
            } else {
              log("home ma aayo");
              return HomepageScreen(); //user logged in
            }
          }
        },
      ),
    );
  }

  Future<void> _initializeApp() async {
    //Show splash for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    setState(() {
      _showOnboarding = !hasSeenOnboarding;
      _initialized = true;
    });
  }
}
