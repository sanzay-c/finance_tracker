import 'package:flutter/material.dart';

const _primaryColor = Color(0xFF48319D);

class ImagePlaceholder extends StatelessWidget {
  final double height;
  final double width;
  final bool isError;

  const ImagePlaceholder({
    required this.height,
    required this.width,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: _primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        isError
            ? Icons.broken_image_rounded
            : Icons.account_balance_wallet_rounded,
        color: _primaryColor.withValues(alpha: 0.35),
      ),
    );
  }
}