import 'dart:developer' show log;

import 'package:finance_tracker/core/constants/app_colors.dart';
import 'package:finance_tracker/core/routing/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CustomAuthButtons extends StatefulWidget {
  const CustomAuthButtons({super.key});

  @override
  State<CustomAuthButtons> createState() => _CustomAuthButtonsState();
}

class _CustomAuthButtonsState extends State<CustomAuthButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              context.go(RouteName.signupTemplateRoute);
              log("k vayo hau yesma bujhnai sakina");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.splashColor.darkModeColor,
              foregroundColor: AppColors.backgroundColor.lightModeColor,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text("Sign Up"),
          ),
        ),
        10.verticalSpace,
        SizedBox(
          width: double.infinity,

          child: ElevatedButton(
            onPressed: () {
              context.go(
                RouteName.loginTemplateRoute,
              ); //go-router package use garesi tyo route call garda yesari call garne hai
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.backgroundColor.lightModeColor,
              foregroundColor: AppColors.splashColor.darkModeColor,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text("Login"),
          ),
        ),
      ],
    );
  }
}
