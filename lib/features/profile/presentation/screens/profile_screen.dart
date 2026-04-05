import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/features/auth/services/auth_service.dart';
import 'package:finance_tracker/features/auth/login/login.dart';
import 'package:finance_tracker/features/profile/presentation/screens/profile_setting_screen.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/core/global_data/global_localizations/l10n_helper/l10n_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
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
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Error: ${e.toString().replaceAll("Exception: ", "")}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red.shade700,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = getColorByTheme(
        context: context, colorClass: AppColors.backgroundColor);
    final textColor = getColorByTheme(
        context: context, colorClass: AppColors.textColor);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final email = FirebaseAuth.instance.currentUser?.email ?? '';

    final initials = (fullName != null && fullName!.trim().isNotEmpty)
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
                    color: _primaryColor.withOpacity(0.12),
                    border: Border.all(
                        color: _primaryColor.withOpacity(0.25), width: 2),
                  ),
                  child: ClipOval(
                    child: profileImageUrl != null &&
                            profileImageUrl!.isNotEmpty
                        ? Image.network(profileImageUrl!, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _InitialsView(initials: initials))
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
                          color: textColor.withOpacity(0.45),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
            Divider(color: textColor.withValues(alpha: 0.07), height: 1),
            const SizedBox(height: 8),

            _TileItem(
              icon: Icons.person_outline_rounded,
              label: l10.editProfile,
              textColor: textColor,
              isDark: isDark,
              onTap: () {},
            ),
            _TileItem(
              icon: Icons.settings_outlined,
              label: l10.setting,
              textColor: textColor,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileSettingScreen()),
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

  const _TileItem({
    required this.icon,
    required this.label,
    required this.textColor,
    required this.isDark,
    required this.onTap,
    this.iconColor,
  });

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
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: textColor is Color
                  ? (textColor as Color).withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}