import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/core/global_data/global_localizations/app_local/app_local.dart';
import 'package:finance_tracker/features/auth/services/auth_service.dart';
import 'package:finance_tracker/features/auth/login/login.dart';
import 'package:finance_tracker/features/profile/presentation/screens/profile_setting_screen.dart';
import 'package:finance_tracker/features/profile/presentation/widgets/profile_item_widget.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/core/global_data/global_localizations/l10n_helper/l10n_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = AuthService();

  String? fullName;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
    fetchUserName();
  }

  Future<void> loadUserProfile() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();

      if (data != null) {
        setState(() {
          fullName = data['fullName'];
          profileImageUrl = data['profileImageUrl'];
        });
      }
    } catch (e) {
      print(" Error loading profile: $e");
    }
  }


  Future<void> fetchUserName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        setState(() {
          fullName = doc['fullName'];
        });
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorByTheme(
        context: context,
        colorClass: AppColors.backgroundColor,
      ),
      appBar: AppBar(
        backgroundColor: getColorByTheme(
          context: context,
          colorClass: AppColors.backgroundColor,
        ),
        title: Text(l10.profile),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            CircleAvatar(
              radius: 100.r,
              backgroundImage:
                  profileImageUrl != null && profileImageUrl!.isNotEmpty
                      ? NetworkImage(profileImageUrl!)
                      : null, 
              child:
                  (profileImageUrl == null || profileImageUrl!.isEmpty)
                      ? Icon(Icons.person, size: 64.r, color: Colors.white)
                      : null,
            ),

            16.verticalSpace,

            Text(
              fullName.toString(),
              style: TextStyle(
                fontSize: 24,
                color: getColorByTheme(
                  context: context,
                  colorClass: AppColors.profileTextColor,
                ),
              ),
            ),
            24.verticalSpace,
            ProfileItemWidget(
              icon: Icons.person,
              text: l10.editProfile,
              onTap: () {},
            ),
            8.verticalSpace,
            ProfileItemWidget(
              icon: Icons.settings,
              text: l10.setting,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileSettingScreen(),
                  ),
                );
              },
            ),
            8.verticalSpace,
            ProfileItemWidget(
              icon: Icons.logout_rounded,
              text: l10.logout,
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();

                // Clear login flag and saved credentials
                await prefs.remove('isLoggedIn');
                await prefs.remove('email');
                await prefs.remove('password');

                await _auth.signOut();

                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false, // Remove all previous routes
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Successfully logged out"),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.black,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
