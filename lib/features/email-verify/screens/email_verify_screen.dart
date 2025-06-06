import 'package:finance_tracker/core/constants/app_colors.dart';
import 'package:finance_tracker/core/routing/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EmailVerifyScreen extends StatelessWidget {
  const EmailVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.lightModeColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset("assets/images/email_verify.png"),
            10.verticalSpace,
            Text("Your email is on the way", style: TextStyle(fontSize: 22.sp)),
            20.verticalSpace,
            Text(
              "Check your email test@test.com and\n follow the instructions to reset your\n password",
            ),
            20.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go(RouteName.loginTemplateRoute);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.splashColor.darkModeColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "Continue",
                ), //yespaxi reset password ma pathauna parni thiyo accord
              ),
            ),
          ],
        ),
      ),
    );
  }
}
