import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/core/global_data/global_localizations/l10n_helper/l10n_helper.dart';
import 'package:finance_tracker/core/global_data/global_theme/bloc/theme_bloc.dart';
import 'package:finance_tracker/core/global_data/language_bloc/bloc/language_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  bool _isNepaliSelected = false;
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    _isDarkTheme = context.read<ThemeBloc>().state is DarkThemeState;
  }

  void _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isNepali = prefs.getBool('isNepaliSelected');

    if (isNepali != null) {
      setState(() {
        _isNepaliSelected = isNepali;
      });
    }
  }

  void _saveLanguagePreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNepaliSelected', value);
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
        title: Text(l10.profileSetting),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.verticalSpace,
            Text(
              l10.langaugeSetting,
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: getColorByTheme(
                  context: context,
                  colorClass: AppColors.profileTextColor,
                ),
              ),
            ),
            8.verticalSpace,
            SwitchListTile(
              title: Text(_isNepaliSelected ? 'Nepali' : 'English'),
              value: _isNepaliSelected,
              onChanged: (value) {
                setState(() {
                  _isNepaliSelected = value;
                });

                _saveLanguagePreference(value);

                if (_isNepaliSelected) {
                  context.read<LanguageBloc>().add(
                    ChangeLanguageEvent(Locale('ne')),
                  );
                } else {
                  context.read<LanguageBloc>().add(
                    ChangeLanguageEvent(Locale('en')),
                  );
                }
              },
              activeColor: Colors.blue,
              inactiveThumbColor: Colors.grey,
            ),

            24.verticalSpace,

            Text(
              l10.themeToggle,
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: getColorByTheme(
                  context: context,
                  colorClass: AppColors.profileTextColor,
                ),
              ),
            ),
            8.verticalSpace,
            SwitchListTile(
              title: Text(_isDarkTheme ? 'Dark Theme' : 'Light Theme'),
              value: _isDarkTheme,
              onChanged: (value) {
                setState(() {
                  _isDarkTheme = value;
                });

                context.read<ThemeBloc>().add(ToggleThemeEvent());
              },
              activeColor: Colors.blue,
              inactiveThumbColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}


