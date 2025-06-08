import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/data/repositories/expense_repository_impl.dart';
import 'package:finance_tracker/domain/entities/transaction_entity.dart';
import 'package:finance_tracker/domain/usecases/add_expense_usecase.dart';
import 'package:finance_tracker/domain/usecases/delete_expense_usecase.dart';
import 'package:finance_tracker/domain/usecases/update_expense_usecase.dart';
import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  final TransactionEntity? existingTransaction;

  const AddExpenseScreen({super.key, this.existingTransaction});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late String selectedType;
  late DateTime selectedDate;
  String selectedCategory = 'Bill & Utility';
  final categories = ['Bill & Utility', 'Food', 'Transport', 'Others'];

  final descriptionController = TextEditingController();
  final totalController = TextEditingController();

  final _repo = ExpenseRepositoryImpl(FirebaseFirestore.instance);
  late final AddExpenseUseCase _addUseCase;
  late final UpdateExpenseUseCase _updateUseCase;
  late final DeleteExpenseUseCase _deleteUseCase;

  bool get isEditing => widget.existingTransaction != null;

  @override
  void initState() {
    super.initState();
    _addUseCase = AddExpenseUseCase(_repo);
    _updateUseCase = UpdateExpenseUseCase(_repo);
    _deleteUseCase = DeleteExpenseUseCase(_repo);

    final existing = widget.existingTransaction;
    selectedType = existing?.type ?? 'Expense';
    selectedDate = existing?.date ?? DateTime.now();
    selectedCategory = existing?.category ?? selectedCategory;
    descriptionController.text = existing?.description ?? '';
    totalController.text = existing?.total.toString() ?? '';
  }

  Future<void> _saveTransaction() async {
    final amount = double.tryParse(totalController.text.trim());
    if (amount == null) {
      _showMessage("Enter a valid amount");
      return;
    }

    final transaction = TransactionEntity(
      id: widget.existingTransaction?.id,
      type: selectedType,
      date: selectedDate,
      category: selectedType == 'Expense' ? selectedCategory : null,
      description: descriptionController.text.trim(),
      total: amount,
    );

    try {
      if (isEditing) {
        await _updateUseCase.execute(transaction.id!, transaction);
        _showMessage("Transaction updated successfully!");
      } else {
        await _addUseCase.execute(transaction);
        _showMessage("Transaction added successfully!");
      }

      Navigator.pop(context, true); // return true to refresh list
    } catch (e) {
      _showMessage("Error: ${e.toString()}");
    }
  }

  Future<void> _deleteTransaction() async {
    if (!isEditing || widget.existingTransaction?.id == null) return;

    try {
      await _deleteUseCase.execute(widget.existingTransaction!.id!);
      _showMessage("Transaction deleted successfully!");
      Navigator.pop(context, true);
    } catch (e) {
      _showMessage("Error: ${e.toString()}");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
          isEditing ? 'Edit ${selectedType}' : 'Add New $selectedType',
          style: TextStyle(color: btnTextColor),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: BackButton(color: btnTextColor),
        actions:
            isEditing
                ? [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: _deleteTransaction,
                  ),
                ]
                : null,
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
                    ? buildExpenseForm(cardColor)
                    : buildIncomeForm(cardColor),
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
                        child: Text(isEditing ? 'Update' : 'Save'),
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

  Widget buildExpenseForm(Color cardColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dateField(cardColor),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedCategory,
          items:
              categories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
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

  Widget buildIncomeForm(Color cardColor) {
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
