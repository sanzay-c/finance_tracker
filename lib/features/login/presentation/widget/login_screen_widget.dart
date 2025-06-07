import 'package:finance_tracker/common/widgets/text_form_widget.dart';
import 'package:finance_tracker/core/constants/app_colors.dart';
import 'package:finance_tracker/core/routing/route_name.dart';
import 'package:finance_tracker/features/login/presentation/cubit/cubit/login_cubit.dart';
import 'package:finance_tracker/features/login/presentation/cubit/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginScreenWidget extends StatelessWidget {
  final LoginState state; // Add this

  LoginScreenWidget({
    required this.state, // Constructor param
    super.key,
  });

  final _formKey = GlobalKey<FormState>();
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

                state is LoginLoading
                    ? CircularProgressIndicator()
                    : SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            await context.read<LoginCubit>().login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );

                            final loginState = context.read<LoginCubit>().state;
                            if (loginState is LoginSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Login Successfull!')),
                              );

                              // Navigate
                              context.go(RouteName.homeTemplateRoute);
                            } else if (loginState is LoginFailure) {
                              // Show error snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${loginState.message}'),
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
                        child: Text("Login"),
                      ),
                    ),

                10.verticalSpace,
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap:
                        () => context.push(RouteName.forgotpassTemplateRoute),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: AppColors.buttonColor.darkModeColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account yet?",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    6.horizontalSpace,
                    InkWell(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: AppColors.buttonColor.darkModeColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: () => context.push(RouteName.signupTemplateRoute),
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
