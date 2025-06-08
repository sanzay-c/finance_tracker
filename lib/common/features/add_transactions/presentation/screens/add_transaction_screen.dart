import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  String transactionType = 'Expense';
  String? selectedWallet;
  String? selectedCategory; 
  DateTime selectedDate = DateTime(2024, 12, 11);
  

  final TextEditingController amountController = TextEditingController(
    text: '0',
  );
  final TextEditingController descriptionController = TextEditingController();

  final List<String> expenseCategories = [
    'Food', 'Transportation', 'Entertainment', 'Shopping', 'Bills'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: getColorByTheme(
          context: context,
          colorClass: AppColors.backgroundColor,
        ),
        title: Text('Add Transaction'),
      ),
      backgroundColor: getColorByTheme(
        context: context,
        colorClass: AppColors.backgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text("Type"),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: transactionType,
                  decoration: _inputDecoration(),
                  items: [
                    DropdownMenuItem(value: 'Expense', child: Text('Expense')),
                    DropdownMenuItem(value: 'Income', child: Text('Income')),
                  ],
                  onChanged: (value) {
                    setState(() => transactionType = value!);
                  },
                  icon: Icon(Icons.keyboard_arrow_down),
                ),

                SizedBox(height: 20),
                Text("Wallet"),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedWallet,
                  decoration: _inputDecoration(),
                  hint: Text("Select Item"),
                  items: [
                    DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                    DropdownMenuItem(value: 'Bank', child: Text('Bank')),
                    DropdownMenuItem(value: 'Card', child: Text('Card')),
                  ],
                  onChanged: (value) {
                    setState(() => selectedWallet = value);
                  },
                  icon: Icon(Icons.keyboard_arrow_down),
                ),

                SizedBox(height: 20),
                Text("Expense Category"),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: _inputDecoration(),
                  hint: Text("Select Category"),
                  items: expenseCategories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedCategory = value);
                  },
                  icon: Icon(Icons.keyboard_arrow_down),
                ),




                SizedBox(height: 20),
                Text("Date"),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: _inputDecoration(),
                      controller: TextEditingController(
                        text:
                            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text("Amount"),
                SizedBox(height: 8),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(),
                ),
                SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    text: 'Description',
                    children: [
                      TextSpan(
                        text: ' (optional)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: _inputDecoration(),
                ),
                SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    text: 'Receipt',
                    children: [
                      TextSpan(
                        text: ' (optional)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.file_upload_outlined, color: Colors.black),
                  label: Text(
                    "Upload Image",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    side: BorderSide(color: Colors.grey.shade400),
                    foregroundColor: Colors.black,
                  ),
                ),

                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade700,
                    minimumSize: Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Submit", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
