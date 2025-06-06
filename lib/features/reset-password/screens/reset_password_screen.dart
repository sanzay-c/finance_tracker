import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _verficationController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Reset Password")),
      body: Column(
        children: [
          Form(
            child: TextFormField(
              controller: _verficationController,
              decoration: InputDecoration(
                labelText: "Verification Code",
                hintText: "Verification nCode",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(),
                ),
              ),
            ),
          ),

          10.verticalSpace,
          Form(
            child: TextFormField(
              controller: _newPasswordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: "New Password",
                hintText: "New Password",
                suffixIcon: IconButton(
                  color: Colors.grey,
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          10.verticalSpace,
          Form(
            child: TextFormField(
              controller: _newPasswordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: " Retype new Password",
                hintText: " Retype new password",
                suffixIcon: IconButton(
                  color: Colors.grey,
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


//yo page maile use gareko xaina hai, yesma rakheko xu yedi paxi OTP garne wala sike vane vanera, tara aile samma sikeko xaina