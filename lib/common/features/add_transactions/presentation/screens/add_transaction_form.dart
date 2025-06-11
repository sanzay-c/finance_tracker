import 'package:finance_tracker/common/features/add_transactions/presentation/blocs/bloc/transaction_bloc.dart';
import 'package:finance_tracker/common/features/add_transactions/presentation/blocs/bloc/transaction_event.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
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
  String? selectedWallet;
  String? selectedCategory;
  DateTime selectedDate = DateTime.now();
  final TextEditingController amountController = TextEditingController(
    text: '0',
  );
  final TextEditingController descriptionController = TextEditingController();

  final List<Map<String, String>> expenseCategories = [
    {'category': 'Food', 'image': 'assets/images/shopping.png'},
    {'category': 'Transportation', 'image': 'assets/images/shopping.png'},
    {'category': 'Entertainment', 'image': 'assets/images/shopping.png'},
    {'category': 'Shopping', 'image': 'assets/images/shopping.png'},
    {'category': 'Bills', 'image': 'assets/images/shopping.png'},
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
      body: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is TransactionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Transaction Added Successfully")),
            );
          }
        },
        builder: (context, state) {
          List<String> wallets = [];
          bool isLoadingWallets = true;

          if (state is WalletsLoaded) {
            wallets = state.wallets;
            isLoadingWallets = false;
          } else if (state is WalletsLoading) {
            isLoadingWallets = true;
          }

          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text("Type"),
                  DropdownButtonFormField<String>(
                    value: transactionType,
                    decoration: _inputDecoration(),
                    items:
                        ['Expense', 'Income']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged:
                        (value) => setState(() => transactionType = value!),
                  ),

                  SizedBox(height: 20),
                  Text("Wallet"),
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
                        onChanged:
                            (value) => setState(() => selectedWallet = value),
                      ),

                  SizedBox(height: 20),
                  Text("Expense Category"),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: _inputDecoration(),
                    hint: Text("Select Category"),
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
                                SizedBox(width: 10),
                                Text(category['category']!),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged:
                        transactionType == 'Expense'
                            ? (value) =>
                                setState(() => selectedCategory = value)
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
                          text:
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
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
                  state is TransactionSubmitting
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final amount =
                                double.tryParse(amountController.text) ?? 0;
                            if (selectedWallet != null) {
                              context.read<TransactionBloc>().add(
                                SubmitTransactionEvent(
                                  transactionType: transactionType,
                                  wallet: selectedWallet!,
                                  category: selectedCategory,
                                  date: selectedDate,
                                  amount: amount,
                                  description:
                                      descriptionController.text.trim(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Select a wallet")),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // Rounded corners
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 13,
                            horizontal: 32,
                          ), // Button padding
                          elevation: 15, // No shadow to maintain transparency
                          side: BorderSide(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            width: 2,
                          ), // Border color and width
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 15, // Text size
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Text weight
                          ),
                        ),
                      ),
                ],
              ),
            ),
          );
        },
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
