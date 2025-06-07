import 'package:finance_tracker/core/constants/app_colors.dart';
import 'package:finance_tracker/features/sign-up/presentation/cubit/signup_cubit.dart';
import 'package:finance_tracker/features/sign-up/presentation/widget/sign_up_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.lightModeColor,
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor.lightModeColor,
      ),
      body: BlocBuilder<SignupCubit, SignupState>(
        builder: (context, state) {
          return SignUpWidget(state: state);
        },
      ),
    );
  }
}



//   @override
//   void dispose() {
//     super.dispose();
//     obscureTextNotifier.dispose(); // important to avoid memory leaks!
//     _userNameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//   }

