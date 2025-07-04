import 'package:finance_tracker/features/add_transactions/domain/repo/transaction_repo.dart';

class WalletTotalIncome {
  final TransactionRepo repository;

  WalletTotalIncome({required this.repository});

  Future<double> call(String walletId) async {
    print('🔍 WalletTotalIncome: Searching for wallet ID: $walletId');

    // Check both income and expense transactions
    final incomeTransactions = await repository
        .getTransactionsByWalletIdAndType(
          walletId: walletId,
          transactionType: 'income',
        );

    final expenseTransactions = await repository
        .getTransactionsByWalletIdAndType(
          walletId: walletId,
          transactionType: 'expense',
        );

    print('📊 Income transactions: ${incomeTransactions.length}');
    print('📊 Expense transactions: ${expenseTransactions.length}');

    // Your original logic for income only
    double total = 0;
    for (var t in incomeTransactions) {
      print('  - Income: ${t.amount ?? 0}');
      total += t.amount ?? 0;
    }

    print('💰 Total income calculated: $total');
    return total;
  }
}
