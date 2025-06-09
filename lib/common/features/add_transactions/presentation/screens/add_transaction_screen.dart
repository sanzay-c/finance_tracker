import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    'Food',
    'Transportation',
    'Entertainment',
    'Shopping',
    'Bills',
  ];

  List<String> wallets = [];
  bool isLoadingWallets = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchWalletsFromFirestore() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('wallets').get();

      final walletNames =
          snapshot.docs.map((doc) => doc['name'] as String).toList();

      setState(() {
        wallets = walletNames;
        isLoadingWallets = false;
      });
    } catch (e) {
      print('Error fetching wallets: $e');
      setState(() {
        isLoadingWallets = false;
      });
    }
  }

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
                8.verticalSpace,
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

                20.verticalSpace,
                Text("Wallet"),
                8.verticalSpace,
                isLoadingWallets
                    ? Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                      value: selectedWallet,
                      decoration: _inputDecoration(),
                      hint: Text("Select Wallet"),
                      items:
                          wallets.map((wallet) {
                            return DropdownMenuItem(
                              value: wallet,
                              child: Text(wallet),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() => selectedWallet = value);
                      },
                      icon: Icon(Icons.keyboard_arrow_down),
                    ),

                20.verticalSpace,
                Text("Expense Category"),
                8.verticalSpace,
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: _inputDecoration(),
                  hint: Text("Select Category"),
                  items:
                      expenseCategories.map((category) {
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
                20.verticalSpace,
                Text("Date"),
                8.verticalSpace,
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

                20.verticalSpace,
                Text("Amount"),
                SizedBox(height: 8),
                8.verticalSpace,
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(),
                ),

                20.verticalSpace,
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
                8.verticalSpace,
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: _inputDecoration(),
                ),

                20.verticalSpace,

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
                8.verticalSpace,
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

                30.verticalSpace,
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Submit logic here
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade700,
                    minimumSize: Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
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
