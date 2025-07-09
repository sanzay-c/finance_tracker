import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/features/dashbord/presentation/bloc/dashboard_bloc.dart';
import 'package:finance_tracker/features/dashbord/presentation/bloc/fetch_transaction_bloc.dart';
import 'package:finance_tracker/features/dashbord/presentation/screens/all_transactions_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? fullName;

  @override
  void initState() {
    super.initState();
    fetchUserName();
    context.read<DashboardBloc>().add(FetchDashboardDataEvent());
    context.read<FetchTransactionBloc>().add(FetchTransactionsEvent());
  }

  Future<void> fetchUserName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();

      if (data != null && data.containsKey('fullName')) {
        setState(() {
          fullName = data['fullName'];
        });
      } else {
        print(" 'fullName' field missing in Firestore doc.");
      }
    } catch (e) {
      print(' Error fetching fullName: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello,", style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  fullName.toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: Icon(Icons.search, color: Colors.black),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DashboardLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  "Total Balance",
                                  style: TextStyle(fontSize: 14),
                                ),
                                Icon(Icons.keyboard_arrow_down, size: 18),
                              ],
                            ),
                            const Icon(Icons.more_horiz),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Rs. ${state.totalBalance.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.arrow_upward, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      "Income",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Rs. ${state.totalIncome.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.arrow_downward, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      "Expenses",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Rs. ${state.totalExpense.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (state is DashboardError) {
                    return Text(state.message);
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),

            SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Transactions",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AllTransactionsScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "View all",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            Expanded(
              child: BlocBuilder<FetchTransactionBloc, FetchTransactionState>(
                builder: (context, state) {
                  if (state is FetchTransactionLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FetchTransactionLoaded) {
                    final transactions = state.transactions;
                    if (transactions.isEmpty) {
                      return Center(child: Text("No transactions found."));
                    }

                    return ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final txn = transactions[index];
                        final isIncome = txn.type == 'income';
                        final sign = isIncome ? "+" : "-";
                        final amountText =
                            "$sign Rs. ${txn.amount.toStringAsFixed(2)}";

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
                                  color: Colors.grey.shade600,
                                  borderRadius: BorderRadius.circular(10),
                                  image:
                                      txn.category != null
                                          ? DecorationImage(
                                            image: NetworkImage(
                                              // Provide the image URL if exists
                                              "https://your-image-source/${txn.category}.png",
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                          : null,
                                ),
                                child:
                                    txn.category == null
                                        ? Icon(
                                          Icons.category,
                                          color: Colors.white,
                                        )
                                        : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      txn.category ?? "No Category",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
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
                                      color:
                                          isIncome ? Colors.green : Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    // Format date to a user-friendly string, e.g. "11 Dec"
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
                  } else if (state is FetchTransactionError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _monthAbbreviation(int month) {
  const months = [
    "", // to make index 1-based
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
  ];
  return months[month];
}
