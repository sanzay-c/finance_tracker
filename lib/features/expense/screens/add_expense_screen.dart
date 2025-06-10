import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/core/global_data/global_theme/bloc/theme_bloc.dart';
import 'package:finance_tracker/features/expense/domain/entities/transaction_entity.dart';
import 'package:finance_tracker/features/expense/presentation/blocs/add_expense/add_expense_bloc.dart';
import 'package:finance_tracker/features/expense/presentation/blocs/add_expense/add_expense_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String selectedType = 'Expense';
  DateTime selectedDate = DateTime.now();
  String selectedCategory = 'Bill & Utility';
  final categories = ['Bill & Utility', 'Food', 'Transport', 'Others'];

  final descriptionController = TextEditingController();
  final totalController = TextEditingController();
  late ExpenseBloc addExpenseBloc;

  @override
  void initState() {
    super.initState();
    addExpenseBloc = context.read<ExpenseBloc>();
  }

  void _saveTransaction() async {
    final double? amount = double.tryParse(totalController.text.trim());
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.somethingWentWrong),
        ),
      );
      return;
    }

    final transaction = TransactionEntity(
      type: selectedType.toLowerCase(),
      date: selectedDate,
      category: selectedType == 'Expense' ? selectedCategory : null,
      description: descriptionController.text.trim(),
      total: amount,
    );

    addExpenseBloc.add(AddExpenseRequested(transaction));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.transactionUpdated)),
    );

    setState(() {
      descriptionController.clear();
      totalController.clear();
      selectedDate = DateTime.now();
      selectedCategory = 'Bill & Utility';
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = getColorByTheme(
      context: context,
      colorClass: AppColors.backgroundColor,
    );
    final cardColor = getColorByTheme(
      context: context,
      colorClass: AppColors.cardColor,
    );
    final btnColor = getColorByTheme(
      context: context,
      colorClass: AppColors.btnColor,
    );
    final btnTextColor = getColorByTheme(
      context: context,
      colorClass: AppColors.btnTextColor,
    );

    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          '${local.addNew} ${selectedType == 'Expense' ? local.expense : local.income}',
          style: TextStyle(color: btnTextColor),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: BackButton(color: btnTextColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            color: btnTextColor,
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleThemeEvent());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children:
                      [local.expense, local.income].map((type) {
                        final isSelected = selectedType == type;
                        return Expanded(
                          child: GestureDetector(
                            onTap:
                                () => setState(
                                  () =>
                                      selectedType =
                                          type == local.expense
                                              ? 'Expense'
                                              : 'Income',
                                ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? btnColor : Colors.grey[300],
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(
                                    type == local.expense ? 20 : 0,
                                  ),
                                  right: Radius.circular(
                                    type == local.income ? 20 : 0,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? btnTextColor
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),
                selectedType == 'Expense'
                    ? buildExpenseForm(cardColor, local)
                    : buildIncomeForm(cardColor, local),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btnColor.withOpacity(0.4),
                          foregroundColor: btnTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: Text(local.cancel),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveTransaction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btnColor,
                          foregroundColor: btnTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: Text(local.save),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildExpenseForm(Color cardColor, AppLocalizations local) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _dateField(cardColor),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        value: selectedCategory,
        items:
            categories
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
        onChanged: (v) => setState(() => selectedCategory = v!),
        decoration: InputDecoration(
          filled: true,
          fillColor: cardColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      const SizedBox(height: 16),
      _descriptionField(cardColor, local.description),
      const SizedBox(height: 16),
      _amountField(cardColor, local.amount),
    ],
  );

  Widget buildIncomeForm(Color cardColor, AppLocalizations local) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _dateField(cardColor),
      const SizedBox(height: 16),
      _descriptionField(cardColor, local.description),
      const SizedBox(height: 16),
      _amountField(cardColor, local.amount),
    ],
  );

  Widget _dateField(Color cardColor) => TextField(
    readOnly: true,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.calendar_today),
      hintText:
          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
      filled: true,
      fillColor: cardColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        setState(() => selectedDate = picked);
      }
    },
  );

  Widget _descriptionField(Color cardColor, String hint) => TextField(
    controller: descriptionController,
    decoration: InputDecoration(
      filled: true,
      fillColor: cardColor,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

  Widget _amountField(Color cardColor, String hint) => TextField(
    controller: totalController,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      filled: true,
      fillColor: cardColor,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
