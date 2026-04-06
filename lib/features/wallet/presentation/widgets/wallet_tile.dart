import 'package:cached_network_image/cached_network_image.dart';
import 'package:finance_tracker/features/wallet/presentation/widgets/image_place_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _primaryColor = Color(0xFF48319D);

class WalletTile extends StatelessWidget {
  final dynamic wallet;
  final Color textColor;
  final bool isDark;

  const WalletTile({
    super.key,
    required this.wallet,
    required this.textColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: wallet.imageUrl != null && wallet.imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: wallet.imageUrl!,
                    height: 110.h,
                    width: 130.w,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => ImagePlaceholder(
                        height: 110.h, width: 130.w),
                    errorWidget: (_, __, ___) => ImagePlaceholder(
                        height: 110.h, width: 130.w, isError: true),
                  )
                : ImagePlaceholder(height: 110.h, width: 130.w),
          ),
          12.horizontalSpace,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wallet.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                6.verticalSpace,
                Text(
                  'Rs.${wallet.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.45),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: _primaryColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}