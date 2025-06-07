import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorByTheme(context: context, colorClass: AppColors.backgroundColor),
      appBar: AppBar(
      backgroundColor: getColorByTheme(context: context, colorClass: AppColors.backgroundColor),
        title: Text("Dashboard"),
        automaticallyImplyLeading: false,
      ),body: Center(
        child: 
        Text('Dashboard'),
      ),
    );
  }
}