import 'dart:developer' show log;
import 'package:finance_tracker/common/widgets/text_form_widget.dart';
import 'package:finance_tracker/core/constants/app_colors.dart';
import 'package:finance_tracker/core/constants/assets_source.dart';
import 'package:finance_tracker/core/routing/route_name.dart';
import 'package:finance_tracker/features/sign-up/presentation/cubit/signup_cubit.dart';
import 'package:finance_tracker/helper/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpWidget extends StatelessWidget {
  final SignupState state;

  SignUpWidget({required this.state, super.key});

  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> obscureTextNotifier = ValueNotifier<bool>(true);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormWidget(
                  controller: _userNameController,
                  labelText: 'Username',
                  hintText: 'Username',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your username";
                    }
                    return null;
                  },
                ),

                15.verticalSpace,
                TextFormWidget(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                ),

                15.verticalSpace,

                ValueListenableBuilder<bool>(
                  valueListenable: obscureTextNotifier,
                  builder: (context, obscureText, child) {
                    return TextFormWidget(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Password',
                      obscureText: obscureText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          obscureTextNotifier.value =
                              !obscureTextNotifier.value;
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password!";
                        }
                        return null;
                      },
                    );
                  },
                ),
                20.verticalSpace,

                state is SignupLoading
                    ? CircularProgressIndicator()
                    : SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            await context.read<SignupCubit>().signup(
                              _userNameController.text.trim(),
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );

                            final signupState =
                                context.read<SignupCubit>().state;
                            if (signupState is SignupSuccess) {
                              // Show snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('User created successfully!'),
                                ),
                              );

                              // Navigate
                              context.go(RouteName.loginTemplateRoute);
                            } else if (signupState is SignupFailure) {
                              // Show error snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${signupState.error}'),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor.darkModeColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text("Sign Up"),
                      ),
                    ),
                10.verticalSpace,
                Text(
                  "Or with",
                  style: TextStyle(color: Colors.grey, fontSize: 22),
                ),
                15.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await _auth.signInWithGoogle();
                        context.go(RouteName.homeTemplateRoute);
                        await GoogleSignIn().signOut();
                      } catch (e) {
                        log("Google Sign In ma xau $e");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundColor.lightModeColor,
                      foregroundColor: AppColors.buttonColor.darkModeColor,
                      side: BorderSide(
                        color: AppColors.buttonColor.lightModeColor,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AssetsSource.googleLogo,
                          height: 50,
                          width: 50,
                        ),

                        10.horizontalSpace,
                        Text(
                          "Sign Up with Google",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                15.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 6),
                    InkWell(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: AppColors.buttonColor.darkModeColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: () => context.push(RouteName.loginTemplateRoute),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
