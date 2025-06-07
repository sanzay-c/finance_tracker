import 'package:finance_tracker/core/constants/app_colors.dart';
import 'package:finance_tracker/core/routing/route_name.dart';
import 'package:finance_tracker/features/onboardings/presentation/screens/onboarding_screen.dart';
import 'package:finance_tracker/features/wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonColor.darkModeColor,
      body: Center(
        child: Text(
          "Monity",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
