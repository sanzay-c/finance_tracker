import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorByTheme(context: context, colorClass: AppColors.backgroundColor),
      appBar: AppBar(
      backgroundColor: getColorByTheme(context: context, colorClass: AppColors.backgroundColor),
        title: Text("Chart"),
        automaticallyImplyLeading: false,
      ),body: Center(
        child: 
        Text('Chart'),
      ),
    );
  }
}