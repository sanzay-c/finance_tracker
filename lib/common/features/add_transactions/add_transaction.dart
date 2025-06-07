import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorByTheme(context: context, colorClass: AppColors.backgroundColor),
      appBar: AppBar(
      backgroundColor: getColorByTheme(context: context, colorClass: AppColors.backgroundColor),
        title: Text("Add transctions"),
        automaticallyImplyLeading: false,
      ),body: Center(
        child: 
        Text('Add transctions'),
      ),
    );
  }
}