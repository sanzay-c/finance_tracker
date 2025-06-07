import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class ProfileItemWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const ProfileItemWidget({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: getColorByTheme(
            context: context,
            colorClass: AppColors.profileBoxColor,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: getColorByTheme(
              context: context,
              colorClass: AppColors.containerBorderColor,
            ),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: getColorByTheme(
                context: context,
                colorClass: AppColors.profileIconColor,
              ),
            ),
            const SizedBox(width: 8),
            Text(text, style:  TextStyle(fontSize: 16, color: getColorByTheme(context: context, colorClass: AppColors.profileTextColor))),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 24,
              color: getColorByTheme(
                context: context,
                colorClass: AppColors.profileIconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
