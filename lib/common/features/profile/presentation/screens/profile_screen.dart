import 'package:finance_tracker/common/features/profile/presentation/screens/profile_setting_screen.dart';
import 'package:finance_tracker/common/features/profile/presentation/widgets/profile_item_widget.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/core/global_data/global_localizations/l10n_helper/l10n_helper.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        title: Text(l10.profile,), 
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(
                'https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW1hZ2V8ZW58MHx8MHx8fDA%3D',
              ),
              // child: Align(
              //   alignment: Alignment.bottomRight,
              //   child: Icon(Icons.edit, color: getColorByTheme(context: context, colorClass: AppColors.profileIconColor), size: 24),
              // ),
            ),
            SizedBox(height: 16),

            Text("Profile Holder Name", style: TextStyle(fontSize: 24, color: getColorByTheme(context: context, colorClass: AppColors.profileTextColor))),
            SizedBox(height: 16),
            ProfileItemWidget(
              icon: Icons.person,
              text: l10.editProfile,
              onTap: () {},
            ),
            SizedBox(height: 8),
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
            SizedBox(height: 8),
            ProfileItemWidget(
              icon: Icons.logout_rounded,
              text: l10.logout,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
