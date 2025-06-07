import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorByTheme(context: context, colorClass: AppColors.backgroundColor),
      appBar: AppBar(
      backgroundColor: getColorByTheme(context: context, colorClass: AppColors.backgroundColor),
        title: Text("Wallet"),
        automaticallyImplyLeading: false,
      ),body: Center(
        child: 
        Text('Wallet'),
      ),
    );
  }
}