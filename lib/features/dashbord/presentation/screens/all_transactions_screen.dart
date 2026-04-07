import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/features/dashbord/presentation/bloc/fetch_transaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<FetchTransactionBloc>().add(FetchTransactionsEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      context.read<FetchTransactionBloc>().add(LoadMoreTransactionsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = getColorByTheme(
      context: context,
      colorClass: AppColors.backgroundColor,
    );
    final textColor = getColorByTheme(
      context: context,
      colorClass: AppColors.textColor,
    );

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: bgColor,
        title: const Text("All Transactions"),
      ),
      body: BlocBuilder<FetchTransactionBloc, FetchTransactionState>(
        builder: (context, state) {
          if (state is FetchTransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FetchTransactionError) {
            return Center(child: Text(state.message));
          }
          if (state is! FetchTransactionLoaded || state.transactions.isEmpty) {
            return const Center(child: Text("No transactions found."));
          }

          final transactions = state.transactions;

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            itemCount: state.hasMore ? transactions.length + 1 : transactions.length,
            itemBuilder: (context, index) {
              if (index >= transactions.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              final txn = transactions[index];
              final isIncome = txn.type == 'income';
              final sign = isIncome ? "+" : "-";
              final amountText = "$sign Rs. ${txn.amount.toStringAsFixed(2)}";

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isIncome ? Colors.green.withValues(alpha: 0.05) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: textColor.withValues(alpha: 0.1)),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: isIncome ? Colors.green : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: isIncome
                          ? const Icon(
                              Icons.arrow_circle_up_outlined,
                              color: Colors.white,
                            )
                          : _getCategoryAsset(txn.category) != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.asset(
                                      _getCategoryAsset(txn.category)!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.category_outlined,
                                  color: Colors.grey,
                                ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isIncome
                                ? "Income"
                                : txn.category ?? "No Category",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            txn.description ?? "No description",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor.withValues(alpha: 0.5),
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
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: isIncome ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${txn.date.day} ${_monthAbbreviation(txn.date.month)}",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: textColor.withValues(alpha: 0.4),
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
