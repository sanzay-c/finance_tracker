import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/core/utils/date_parser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';

class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({super.key});

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
        title: const Text("All Transactions"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('transactions')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .orderBy('date', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No transactions found."));
          }

          final transactions = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return TransactionEntity(
              id: data['id'],
              type: data['type'],
              walletId: data['walletId'],
              category: data['category'],
              date: DateParser.parse(data['date']),
              amount: (data['amount'] as num).toDouble(),
              description: data['description'],
            );
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final txn = transactions[index];
              final isIncome = txn.type == 'income';
              final sign = isIncome ? "+" : "-";
              final amountText = "$sign Rs. ${txn.amount.toStringAsFixed(2)}";

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: isIncome ? Colors.green : Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: isIncome
                          ? const Icon(
                              Icons.arrow_circle_up_outlined,
                              color: Colors.white,
                            )
                          : _getCategoryAsset(txn.category) != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    _getCategoryAsset(txn.category)!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.category,
                                  color: Colors.white,
                                ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isIncome
                                ? "Income"
                                : txn.category ?? "No Category",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: getColorByTheme(
                                context: context,
                                colorClass: AppColors.textColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            txn.description ?? "No description",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          amountText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isIncome ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${txn.date.day} ${_monthAbbreviation(txn.date.month)}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String? _getCategoryAsset(String? category) {
    if (category == null) return null;
    final mapping = {
      'Food': 'assets/images/food.png',
      'Transportation': 'assets/images/transportation.png',
      'Entertainment': 'assets/images/entertainment.png',
      'Shopping': 'assets/images/shopping.png',
      'Health': 'assets/images/bills.png',
      'Education': 'assets/images/education.png',
    };
    return mapping[category];
  }

  String _monthAbbreviation(int month) {
    const months = [
      "", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month];
  }
}
