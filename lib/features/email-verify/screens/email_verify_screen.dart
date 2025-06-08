import 'package:finance_tracker/core/constants/app_colors.dart';
import 'package:finance_tracker/core/constants/assets_source.dart';
import 'package:finance_tracker/core/routing/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EmailVerifyScreen extends StatelessWidget {
  final String email;
  const EmailVerifyScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.lightModeColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AssetsSource.verifyEmail),
            10.verticalSpace,
            Text(
              "Your email is on the way!",
              style: TextStyle(fontSize: 22.sp),
            ),
            20.verticalSpace,
            Text(
              "Check your email $email and\n follow the instructions to reset your\n password",
            ),
            20.verticalSpace,
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go(RouteName.loginTemplateRoute);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor.darkModeColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
