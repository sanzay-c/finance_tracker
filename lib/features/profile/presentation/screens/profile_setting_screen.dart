import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/core/global_data/global_localizations/l10n_helper/l10n_helper.dart';
import 'package:finance_tracker/core/global_data/global_theme/bloc/theme_bloc.dart';
import 'package:finance_tracker/core/global_data/language_bloc/bloc/language_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _primaryColor = Color(0xFF48319D);

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

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isNepali = prefs.getBool('isNepaliSelected');
    if (isNepali != null && mounted) {
      setState(() => _isNepaliSelected = isNepali);
    }
  }

  Future<void> _saveLanguagePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNepaliSelected', value);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = getColorByTheme(
        context: context, colorClass: AppColors.backgroundColor);
    final textColor = getColorByTheme(
        context: context, colorClass: AppColors.textColor);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          l10.profileSetting,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // ── Language ──────────────────────────────────────────────────
          _SectionLabel(label: l10.langaugeSetting, textColor: textColor),
          const SizedBox(height: 10),
          _SettingTile(
            isDark: isDark,
            textColor: textColor,
            child: Row(
              children: [
                Icon(Icons.language_rounded,
                    color: _primaryColor, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    _isNepaliSelected ? 'Nepali' : 'English',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                Switch.adaptive(
                  value: _isNepaliSelected,
                  onChanged: (value) {
                    setState(() => _isNepaliSelected = value);
                    _saveLanguagePreference(value);
                    context.read<LanguageBloc>().add(
                          ChangeLanguageEvent(
                              Locale(value ? 'ne' : 'en')),
                        );
                  },
                  activeThumbColor: _primaryColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ── Appearance ────────────────────────────────────────────────
          _SectionLabel(label: l10.themeToggle, textColor: textColor),
          const SizedBox(height: 10),
          _SettingTile(
            isDark: isDark,
            textColor: textColor,
            child: Row(
              children: [
                Icon(
                  _isDarkTheme
                      ? Icons.nights_stay_rounded
                      : Icons.wb_sunny_rounded,
                  color: _primaryColor,
                  size: 22,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    _isDarkTheme ? 'Dark Theme' : 'Light Theme',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                Switch.adaptive(
                  value: _isDarkTheme,
                  onChanged: (value) {
                    setState(() => _isDarkTheme = value);
                    context.read<ThemeBloc>().add(ToggleThemeEvent());
                  },
                  activeThumbColor: _primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color textColor;
  const _SectionLabel({required this.label, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w600,
        color: textColor.withValues(alpha: 0.45),
        letterSpacing: 0.6,
      ),
    );
  }
}

// ─── Setting Tile ─────────────────────────────────────────────────────────────

class _SettingTile extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final Color textColor;
  const _SettingTile(
      {required this.child, required this.isDark, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: textColor.withValues(alpha: 0.07)),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: child,
    );
  }
}