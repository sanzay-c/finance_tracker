import 'dart:developer';

import 'package:finance_tracker/core/routing/route_name.dart';
import 'package:finance_tracker/helper/auth/auth_service.dart';
import 'package:finance_tracker/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Forgot Password"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't worry.\nEnter your email and we'll send you a link to reset your\npassword.",
              style: TextStyle(fontSize: 20.sp),
            ),
            20.verticalSpace,
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Email',
                  focusColor: AppColors.splashColor.darkModeColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email!";
                  }
                  return null;
                },
              ),
            ),
            20.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _auth.sendPasswordResetLink(_emailController.text);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(
                  //       "An email for password reset has been sent to your email",
                  //     ),
                  //   ),
                  // );

                  if (_formKey.currentState!.validate()) {
                    // Validation passed → Navigate
                    context.push(RouteName.verifyemailTemplateRoute);
                  } else {
                    log('Form validation failed');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.splashColor.darkModeColor,
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
