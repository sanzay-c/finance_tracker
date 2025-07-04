import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => AddTransactionFormState();
}

class AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  String transactionType = 'Expense';
  String? selectedWalletId;
  String? selectedCategory;
  DateTime selectedDate = DateTime.now();
  final TextEditingController amountController = TextEditingController(text: '0');
  final TextEditingController descriptionController = TextEditingController();

  final List<Map<String, String>> expenseCategories = [
    {'category': 'Food', 'image': 'assets/images/shopping.png'},
    {'category': 'Transportation', 'image': 'assets/images/shopping.png'},
    {'category': 'Entertainment', 'image': 'assets/images/shopping.png'},
    {'category': 'Shopping', 'image': 'assets/images/shopping.png'},
    {'category': 'Bills', 'image': 'assets/images/shopping.png'},
  ];

  final List<Map<String, String>> wallets = [
    {'id': '1', 'name': 'Cash'},
    {'id': '2', 'name': 'Bank'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorByTheme(
        context: context,
        colorClass: AppColors.backgroundColor,
      ),
      appBar: AppBar(
        backgroundColor: getColorByTheme(
          context: context,
          colorClass: AppColors.backgroundColor,
        ),
        title: Text("Add Transaction"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Type"),
              DropdownButtonFormField<String>(
                dropdownColor: getColorByTheme(
                  context: context,
                  colorClass: AppColors.backgroundColor,
                ),
                value: transactionType,
                decoration: _inputDecoration(),
                items: ['Expense', 'Income']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => transactionType = value!),
              ),
              SizedBox(height: 20),
              Text("Wallet"),
              DropdownButtonFormField<String>(
                dropdownColor: getColorByTheme(
                  context: context,
                  colorClass: AppColors.backgroundColor,
                ),
                value: selectedWalletId,
                decoration: _inputDecoration(),
                hint: Text("Select Wallet"),
                items: wallets.map((wallet) {
                  return DropdownMenuItem<String>(
                    value: wallet['id'],
                    child: Text(wallet['name']!),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedWalletId = value),
              ),
              SizedBox(height: 20),
              Text("Expense Category"),
              DropdownButtonFormField<String>(
                dropdownColor: getColorByTheme(
                  context: context,
                  colorClass: AppColors.backgroundColor,
                ),
                value: selectedCategory,
                decoration: _inputDecoration(),
                hint: Text("Select Category"),
                items: expenseCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['category'],
                    child: Row(
                      children: [
                        Image.asset(
                          category['image']!,
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 10),
                        Text(category['category']!),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: transactionType == 'Expense'
                    ? (value) => setState(() => selectedCategory = value)
                    : null,
              ),
              SizedBox(height: 20),
              Text("Date"),
              GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() => selectedDate = pickedDate);
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: _inputDecoration(),
                    controller: TextEditingController(
                      text: "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Amount"),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(),
              ),
              SizedBox(height: 20),
              Text("Description (optional)"),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: _inputDecoration(),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: getColorByTheme(
                    context: context,
                    colorClass: AppColors.backgroundColor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 13,
                    horizontal: 32,
                  ),
                  elevation: 15,
                  side: BorderSide(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    width: 2,
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
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
