import 'package:finance_tracker/core/constants/app_color.dart';
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

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

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
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Add New ${selectedType}',
          style: TextStyle(color: btnTextColor),
        ),
        centerTitle: true,
        leading: Icon(Icons.arrow_back, color: btnTextColor),
        actions: [Icon(Icons.settings, color: btnTextColor)],
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Toggle: Expense / Income
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedType = 'Expense'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color:
                                selectedType == 'Expense'
                                    ? btnColor
                                    : Colors.grey[300],
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Expense',
                              style: TextStyle(
                                color:
                                    selectedType == 'Expense'
                                        ? btnTextColor
                                        : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedType = 'Income'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color:
                                selectedType == 'Income'
                                    ? btnColor
                                    : Colors.grey[300],
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Income',
                              style: TextStyle(
                                color:
                                    selectedType == 'Income'
                                        ? btnTextColor
                                        : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                selectedType == 'Expense'
                    ? buildExpenseForm(cardColor, btnTextColor)
                    : buildIncomeForm(cardColor, btnTextColor),

                const SizedBox(height: 20),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
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
                        onPressed: () {
                          // Save logic
                        },
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
        // Date Picker
        TextField(
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
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() => selectedDate = picked);
            }
          },
        ),
        const SizedBox(height: 16),

        // Category Dropdown
        DropdownButtonFormField<String>(
          value: selectedCategory,
          items:
              categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
          onChanged: (value) => setState(() => selectedCategory = value!),
          decoration: InputDecoration(
            filled: true,
            fillColor: cardColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 16),

        // Description
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(
            filled: true,
            fillColor: cardColor,
            hintText: 'Description (Optional)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 16),

        // Total Amount
        TextField(
          controller: totalController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: cardColor,
            hintText: 'Total',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 16),

        // Image Upload Section
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Expense receipt images',
            style: TextStyle(fontWeight: FontWeight.bold, color: btnTextColor),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: uploadBox(cardColor)),
            const SizedBox(width: 10),
            Expanded(child: uploadBox(cardColor)),
          ],
        ),
      ],
    );
  }

  Widget buildIncomeForm(Color cardColor, Color btnTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Picker
        TextField(
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
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() => selectedDate = picked);
            }
          },
        ),
        const SizedBox(height: 16),

        // Description
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(
            filled: true,
            fillColor: cardColor,
            hintText: 'Source of Income',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 16),

        // Total Amount
        TextField(
          controller: totalController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: cardColor,
            hintText: 'Total',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget uploadBox(Color cardColor) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(Icons.add_circle, color: Colors.deepOrange, size: 30),
      ),
    );
  }
}
