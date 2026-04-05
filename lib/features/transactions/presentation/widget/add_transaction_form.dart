import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_tracker/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:finance_tracker/features/wallet/data/models/wallet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final TextEditingController amountController = TextEditingController(
    text: '0',
  );
  final TextEditingController descriptionController = TextEditingController();

  final List<Map<String, String>> expenseCategories = [
    {'category': 'Food', 'image': 'assets/images/food.png'},
    {'category': 'Transportation', 'image': 'assets/images/transportation.png'},
    {'category': 'Entertainment', 'image': 'assets/images/entertainment.png'},
    {'category': 'Shopping', 'image': 'assets/images/shopping.png'},
    {'category': 'Health', 'image': 'assets/images/bills.png'},
    {'category': 'Education', 'image': 'assets/images/education.png'},
  ];

  final List<Map<String, String>> wallets = [
    {'id': '1', 'name': 'Cash'},
    {'id': '2', 'name': 'Bank'},
  ];

  List<WalletModel> walletList = [];

  @override
  void initState() {
    super.initState();
    fetchWallets();
  }

  Future<void> fetchWallets() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('wallets')
        .where('uid', isEqualTo: uid)
        .get();
    final wallets =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return WalletModel.fromMap(data);
        }).toList();

    setState(() {
      walletList = wallets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Transaction added successfully")),
          );
        } else if (state is TransactionFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: ${state.error}")));
        }
      },
      child: Scaffold(
        backgroundColor: getColorByTheme(
          context: context,
          colorClass: AppColors.backgroundColor,
        ),
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,

          backgroundColor: getColorByTheme(
            context: context,
            colorClass: AppColors.backgroundColor,
          ),
          title: const Text("Add Transaction"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text(
                  "Type",
                  style: TextStyle(
                    color: getColorByTheme(
                      context: context,
                      colorClass: AppColors.textColor,
                    ),
                  ),
                ),
                DropdownButtonFormField<String>(
                  dropdownColor: getColorByTheme(
                    context: context,
                    colorClass: AppColors.backgroundColor,
                  ),
                  initialValue: transactionType,
                  decoration: _inputDecoration(),
                  items:
                      ['Expense', 'Income']
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: TextStyle(
                                  color: getColorByTheme(
                                    context: context,
                                    colorClass: AppColors.textColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (value) => setState(() => transactionType = value!),
                ),
                const SizedBox(height: 20),
                Text(
                  "Wallet",
                  style: TextStyle(
                    color: getColorByTheme(
                      context: context,
                      colorClass: AppColors.textColor,
                    ),
                  ),
                ),
                DropdownButtonFormField<String>(
                  initialValue: selectedWalletId,
                  dropdownColor: getColorByTheme(
                    context: context,
                    colorClass: AppColors.backgroundColor,
                  ),
                  decoration: _inputDecoration(),
                  hint: const Text("Select Wallet"),
                  items:
                      walletList.map((wallet) {
                        return DropdownMenuItem<String>(
                          value: wallet.id,
                          child: Text(
                            wallet.name,
                            style: TextStyle(
                              color: getColorByTheme(
                                context: context,
                                colorClass: AppColors.textColor,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged:
                      (value) => setState(() => selectedWalletId = value),
                  validator:
                      (value) =>
                          value == null ? 'Please select a wallet' : null,
                ),
                const SizedBox(height: 20),
                Text(
                  "Expense Category",
                  style: TextStyle(
                    color: getColorByTheme(
                      context: context,
                      colorClass: AppColors.textColor,
                    ),
                  ),
                ),
                DropdownButtonFormField<String>(
                  dropdownColor: getColorByTheme(
                    context: context,
                    colorClass: AppColors.backgroundColor,
                  ),
                  initialValue: selectedCategory,
                  decoration: _inputDecoration(),
                  hint: const Text("Select Category"),
                  items:
                      expenseCategories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category['category'],
                          child: Row(
                            children: [
                              Image.asset(
                                category['image']!,
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                category['category']!,
                                style: TextStyle(
                                  color: getColorByTheme(
                                    context: context,
                                    colorClass: AppColors.textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged:
                      transactionType == 'Expense'
                          ? (value) => setState(() => selectedCategory = value)
                          : null,
                  validator:
                      transactionType == 'Expense'
                          ? (value) =>
                              value == null ? 'Please select a category' : null
                          : null,
                ),
                const SizedBox(height: 20),
                Text(
                  "Date",
                  style: TextStyle(
                    color: getColorByTheme(
                      context: context,
                      colorClass: AppColors.textColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      barrierColor: const Color.fromARGB(81, 0, 0, 0),
                    );
                    if (pickedDate != null) {
                      setState(() => selectedDate = pickedDate);
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      style: TextStyle(
                        color: getColorByTheme(
                          context: context,
                          colorClass: AppColors.textColor,
                        ),
                      ),
                      decoration: _inputDecoration(),
                      controller: TextEditingController(
                        text:
                            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Amount",
                  style: TextStyle(
                    color: getColorByTheme(
                      context: context,
                      colorClass: AppColors.textColor,
                    ),
                  ),
                ),
                TextFormField(
                  style: TextStyle(
                    color: getColorByTheme(
                      context: context,
                      colorClass: AppColors.textColor,
                    ),
                  ),
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter amount';
                    if (double.tryParse(value) == null) return 'Invalid number';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  "Description (optional)",
                  style: TextStyle(
                    color: getColorByTheme(
                      context: context,
                      colorClass: AppColors.textColor,
                    ),
                  ),
                ),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getColorByTheme(
                      context: context,
                      colorClass: AppColors.backgroundColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 32,
                    ),
                    elevation: 15,
                    side: BorderSide(
                      color: Color(0xFF48319D),

                      // getColorByTheme(context: context, colorClass: AppColors.buttonBorderSide),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: getColorByTheme(
                        context: context,
                        colorClass: AppColors.textColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitTransaction() {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(amountController.text) ?? 0.0;
      final isExpense = transactionType.toLowerCase() == 'expense';

      if (isExpense) {
        final selectedWallet = walletList.firstWhere(
          (w) => w.id == selectedWalletId,
          orElse: () => WalletModel(
            id: '',
            name: '',
            amount: 0,
            uid: '',
            createdAt: DateTime.now(),
            totalExpenses: 0.0,
            totalIncome: 0.0,
            imageUrl: '',
          ),
        );

        if (selectedWallet.amount < amount) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Insufficient balance in ${selectedWallet.name} (Available: Rs. ${selectedWallet.amount.toStringAsFixed(2)})',
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      final transaction = TransactionEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: transactionType.toLowerCase(),
        walletId: selectedWalletId!,
        category: transactionType == 'Expense' ? selectedCategory : null,
        date: selectedDate,
        amount: amount,
        description:
            descriptionController.text.trim().isEmpty
                ? null
                : descriptionController.text.trim(),
      );

      context.read<TransactionBloc>().add(AddTransactionEvent(transaction));
    }
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
