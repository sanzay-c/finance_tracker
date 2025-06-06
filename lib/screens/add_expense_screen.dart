// lib/presentation/screens/add_expense_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/data/repositories/expense_repository_impl.dart';
import 'package:finance_tracker/domain/entities/transaction_entity.dart';
import 'package:finance_tracker/domain/usecases/add_expense_usecase.dart';

import 'package:flutter/material.dart';

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

  final AddExpenseUseCase useCase = AddExpenseUseCase(
    ExpenseRepositoryImpl(FirebaseFirestore.instance),
  );

  void _saveTransaction() async {
    try {
      final double? amount = double.tryParse(totalController.text.trim());
      if (amount == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Enter a valid amount")));
        return;
      }

      final transaction = TransactionEntity(
        type: selectedType,
        date: selectedDate,
        category: selectedType == 'Expense' ? selectedCategory : null,
        description: descriptionController.text.trim(),
        total: amount,
      );

      await useCase.execute(transaction);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaction added successfully!")),
      );

      Navigator.pop(context); // or clear fields
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Add New $selectedType',
          style: TextStyle(color: btnTextColor),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: BackButton(color: btnTextColor),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Toggle
                Row(
                  children:
                      ['Expense', 'Income'].map((type) {
                        final isSelected = selectedType == type;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedType = type),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? btnColor : Colors.grey[300],
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(
                                    type == 'Expense' ? 20 : 0,
                                  ),
                                  right: Radius.circular(
                                    type == 'Income' ? 20 : 0,
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
                    ? buildExpenseForm(cardColor, btnTextColor)
                    : buildIncomeForm(cardColor, btnTextColor),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btnColor.withOpacity(0.4),
                          foregroundColor: btnTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveTransaction,
                        child: const Text('Save'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btnColor,
                          foregroundColor: btnTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
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

  Widget buildExpenseForm(Color cardColor, Color btnTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dateField(cardColor),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedCategory,
          items:
              categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
          onChanged: (value) => setState(() => selectedCategory = value!),
          decoration: InputDecoration(
            filled: true,
            fillColor: cardColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 16),
        _descriptionField(cardColor, 'Description (Optional)'),
        const SizedBox(height: 16),
        _amountField(cardColor),
      ],
    );
  }

  Widget buildIncomeForm(Color cardColor, Color btnTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dateField(cardColor),
        const SizedBox(height: 16),
        _descriptionField(cardColor, 'Source of Income'),
        const SizedBox(height: 16),
        _amountField(cardColor),
      ],
    );
  }

  Widget _dateField(Color cardColor) {
    return TextField(
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
        if (picked != null) setState(() => selectedDate = picked);
      },
    );
  }

  Widget _descriptionField(Color cardColor, String hint) {
    return TextField(
      controller: descriptionController,
      decoration: InputDecoration(
        filled: true,
        fillColor: cardColor,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _amountField(Color cardColor) {
    return TextField(
      controller: totalController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: cardColor,
        hintText: 'Total Amount',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
