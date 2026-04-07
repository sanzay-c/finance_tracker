import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/features/auth/services/auth_service.dart';
import 'package:finance_tracker/features/auth/login/login.dart';
import 'package:finance_tracker/features/profile/presentation/screens/profile_setting_screen.dart';
import 'package:finance_tracker/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/core/global_data/global_localizations/l10n_helper/l10n_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finance_tracker/core/services/pdf_report_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _primaryColor = Color(0xFF48319D);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = AuthService();
  String? fullName;
  String? profileImageUrl;
  bool _isGeneratingReport = false;
  DateTime _selectedDateForReport = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null && mounted) {
        setState(() {
          fullName = data['fullName'];
          profileImageUrl = data['profileImageUrl'];
        });
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  Future<void> _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('email');
      await prefs.remove('password');
      await _auth.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Logged out successfully'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString().replaceAll("Exception: ", "")}',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  Future<void> _showMonthPicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateForReport,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'Select Report Month',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateForReport = picked;
      });
      _generateReport();
    }
  }

  Future<void> _generateReport() async {
    setState(() => _isGeneratingReport = true);
    try {
      await PdfReportService.generateMonthlyReport(_selectedDateForReport);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report generated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString().replaceAll("Exception: ", "")}',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingReport = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = getColorByTheme(
      context: context,
      colorClass: AppColors.backgroundColor,
    );
    final textColor = getColorByTheme(
      context: context,
      colorClass: AppColors.textColor,
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final email = FirebaseAuth.instance.currentUser?.email ?? '';

    final initials =
        (fullName != null && fullName!.trim().isNotEmpty)
            ? fullName!
                .trim()
                .split(' ')
                .map((e) => e[0])
                .take(2)
                .join()
                .toUpperCase()
            : '?';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l10.profile,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _primaryColor.withValues(alpha: 0.12),
                    border: Border.all(
                      color: _primaryColor.withValues(alpha: 0.25),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child:
                        profileImageUrl != null && profileImageUrl!.isNotEmpty
                            ? Image.network(
                              profileImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) =>
                                      _InitialsView(initials: initials),
                            )
                            : _InitialsView(initials: initials),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName ?? '—',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 13,
                          color: textColor.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
            Text(
              "REPORT",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor.withValues(alpha: 0.5),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            _TileItem(
              icon: Icons.picture_as_pdf_outlined,
              label: 'Download PDF Report',
              textColor: textColor,
              isDark: isDark,
              onTap: _isGeneratingReport ? () {} : _showMonthPicker,
              trailing:
                  _isGeneratingReport
                      ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _primaryColor,
                        ),
                      )
                      : Text(
                        DateFormat('MMM yyyy').format(_selectedDateForReport),
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor.withValues(alpha: 0.4),
                        ),
                      ),
            ),

            const SizedBox(height: 24),
            Text(
              "SETTING",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor.withValues(alpha: 0.5),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            _TileItem(
              icon: Icons.person_outline_rounded,
              label: l10.editProfile,
              textColor: textColor,
              isDark: isDark,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => EditProfileScreen(
                          currentName: fullName,
                          currentImageUrl: profileImageUrl,
                        ),
                  ),
                );
                if (result == true) {
                  _loadUserProfile();
                }
              },
            ),
            _TileItem(
              icon: Icons.settings_outlined,
              label: l10.setting,
              textColor: textColor,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileSettingScreen()),
                );
              },
            ),

            const SizedBox(height: 8),
            Divider(color: textColor.withValues(alpha: 0.07), height: 1),
            const SizedBox(height: 8),

            _TileItem(
              icon: Icons.logout_rounded,
              label: l10.logout,
              textColor: Colors.red,
              isDark: isDark,
              iconColor: Colors.red,
              onTap: _logout,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _InitialsView extends StatelessWidget {
  final String initials;
  const _InitialsView({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: _primaryColor,
        ),
      ),
    );
  }
}

class _TileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color textColor;
  final Color? iconColor;
  final bool isDark;
  final VoidCallback onTap;
  final Widget? trailing;

  const _TileItem({
    required this.icon,
    required this.label,
    required this.textColor,
    this.iconColor,
    required this.isDark,
    required this.onTap,
    this.trailing,
  });

  //   required this.isDark,
  //   required this.onTap,
  //   this.iconColor,
  //   this.trailing,
  // });

  @override
  Widget build(BuildContext context) {
    final ic = iconColor ?? _primaryColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: ic, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  // ignore: unnecessary_type_check
                  color:
                      // ignore: unnecessary_type_check
                      textColor is Color
                          // ignore: unnecessary_cast
                          ? (textColor as Color).withValues(alpha: 0.3)
                          : Colors.grey.withValues(alpha: 0.3),
                ),
          ],
        ),
      ),
    );
  }
}