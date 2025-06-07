import 'package:finance_tracker/core/constants/app_colors.dart';
import 'package:finance_tracker/features/login/presentation/cubit/cubit/login_cubit.dart';
import 'package:finance_tracker/features/login/presentation/cubit/cubit/login_state.dart';
import 'package:finance_tracker/features/login/presentation/widget/login_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return LoginScreenWidget(
            state: state, // Pass state to the widget
          );
        },
      ),
    );
  }
}

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<StatefulWidget> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final ValueNotifier<bool> obscureTextNotifier = ValueNotifier<bool>(true);

//   @override
//   void dispose() {
//     super.dispose();
//     obscureTextNotifier.dispose(); // important to avoid memory leaks!
//     _emailController.dispose();
//     _passwordController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text("Login"),
//         centerTitle: true,
//         backgroundColor: AppColors.backgroundColor.lightModeColor,
//       ),

//       body: BlocConsumer<LoginCubit, LoginState>(
//         listener: (context, state) {
//           if (state is LoginSuccess) {
//             context.go(RouteName.homeTemplateRoute);
//           } else if (state is LoginFailure) {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(SnackBar(content: Text(state.message)));
//           }
//         },
//         builder: (context, state) {
//           return Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Form(
//               key: _formKey,
//               child: ListView(
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       TextFormField(
//                         controller: _emailController,
//                         decoration: InputDecoration(
//                           labelText: 'Email',
//                           hintText: 'Email',
//                           focusColor: AppColors.splashColor.darkModeColor,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Please enter your email";
//                           }
//                           return null;
//                         },
//                       ),

//                       15.verticalSpace,
//                       ValueListenableBuilder<bool>(
//                         valueListenable: obscureTextNotifier,
//                         builder: (context, obscureText, child) {
//                           return TextFormField(
//                             controller: _passwordController,
//                             obscureText: obscureText,
//                             decoration: InputDecoration(
//                               labelText: 'Password',
//                               hintText: 'Password',
//                               focusColor: AppColors.splashColor.darkModeColor,
//                               suffixIcon: IconButton(
//                                 color: Colors.grey,
//                                 icon: Icon(
//                                   obscureText
//                                       ? Icons.visibility_off
//                                       : Icons.visibility,
//                                 ),
//                                 onPressed: () {
//                                   obscureTextNotifier.value =
//                                       !obscureTextNotifier.value;
//                                 },
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "Please enter your password!";
//                               }
//                               return null;
//                             },
//                           );
//                         },
//                       ),

//                       20.verticalSpace,

//                       state is LoginLoading
//                           ? CircularProgressIndicator()
//                           : SizedBox(
//                             height: 50,
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 if (_formKey.currentState != null &&
//                                     _formKey.currentState!.validate()) {
//                                   context.read<LoginCubit>().login(
//                                     _emailController.text.trim(),
//                                     _passwordController.text.trim(),
//                                   );
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor:
//                                     AppColors.splashColor.darkModeColor,
//                                 foregroundColor: Colors.white,
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 32,
//                                   vertical: 12,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                               ),
//                               child: Text("Login"),
//                             ),
//                           ),

//                       10.verticalSpace,
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: InkWell(
//                           onTap:
//                               () => context.push(
//                                 RouteName.forgotpassTemplateRoute,
//                               ),
//                           child: Text(
//                             "Forgot Password?",
//                             style: TextStyle(
//                               color: AppColors.splashColor.darkModeColor,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       ),

//                       10.verticalSpace,
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Don't have an account yet?",
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w400,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           6.horizontalSpace,
//                           InkWell(
//                             child: Text(
//                               "Sign Up",
//                               style: TextStyle(
//                                 color: AppColors.splashColor.darkModeColor,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                             onTap:
//                                 () =>
//                                     context.push(RouteName.signupTemplateRoute),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Future<void> _login() async {
//   //   if (_formKey.currentState == null || !_formKey.currentState!.validate())
//   //     return;

//   //   try {
//   //     final user = await _auth.loginUserWithEmailAndPassword(
//   //       _emailController.text.trim(),
//   //       _passwordController.text.trim(),
//   //     );
//   //     if (user != null) {
//   //       log('User Login Successful');
//   //       if (!mounted) return;
//   //       context.push(RouteName.homeTemplateRoute);
//   //     }
//   //   } catch (e) {
//   //     log("Login Failed: $e");
//   //     if (!mounted) return; //to know whether widget is still active or not

//   //     // Friendly message for wrong email/password
//   //     String errorMessage = "You entered wrong email or password.";

//   //     // If using FirebaseAuthException, you can check error codes:
//   //     if (e is FirebaseAuthException) {
//   //       if (e.code == 'user-not-found' || e.code == 'wrong-password') {
//   //         errorMessage = "You entered wrong email or password.";
//   //       } else {
//   //         errorMessage = e.message ?? "An unknown error occurred.";
//   //       }
//   //     }

//   //     ScaffoldMessenger.of(
//   //       context,
//   //     ).showSnackBar(SnackBar(content: Text(errorMessage)));
//   //   }
//   // }
// }
