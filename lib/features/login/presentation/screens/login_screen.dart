import 'dart:developer';
import 'package:finance_tracker/core/constants/app_colors.dart';
import 'package:finance_tracker/core/routing/route_name.dart';
import 'package:finance_tracker/helper/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:developer' show log;
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> obscureTextNotifier = ValueNotifier<bool>(true);

  @override
  void dispose() {
    super.dispose();
    obscureTextNotifier.dispose(); // important to avoid memory leaks!
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor.lightModeColor,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                        return "Please enter your email";
                      }
                      return null;
                    },
                  ),
                ),
                10.verticalSpace,
                ValueListenableBuilder<bool>(
                  valueListenable: obscureTextNotifier,
                  builder: (context, obscureText, child) {
                    return TextFormField(
                      key: _formKey,
                      controller: _passwordController,
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Password',
                        focusColor: AppColors.splashColor.darkModeColor,
                        suffixIcon: IconButton(
                          color: Colors.grey,
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            obscureTextNotifier.value =
                                !obscureTextNotifier.value;
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
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
                10.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.splashColor.darkModeColor,
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
                        color: AppColors.splashColor.darkModeColor,
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
                          color: AppColors.splashColor.darkModeColor,
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

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final user = await _auth.loginUserWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (user != null) {
        log('User Login Successful');
        if (!mounted) return;
        context.push(RouteName.homeTemplateRoute);
      }
    } catch (e) {
      log("Login Failed: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed: $e")));
    }
  }

  // _login() async {
  //   if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Please enter both required fields")),
  //     );
  //     return;
  //   }
  //   try {
  //     final user = await _auth.loginUserWithEmailAndPassword(
  //       _emailController.text,
  //       _passwordController.text,
  //     );
  //     if (user != null) {
  //       log('User Login Successfull');
  //       Navigator.pushReplacementNamed(context, "/home");
  //     }
  //     //aba yo comment gareko part sidhai wrapper le gardinxa , wrapper main.dart ma suru ma call garesi kun page kati khera call garne login kati khera home sab wrapper bata aeraxa
  //   } catch (e) {
  //     log("Login Failed:$e");
  //     if (!mounted) return; //  Safe check before using context
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Login failed: $e")));
  //   }
  // }
}
