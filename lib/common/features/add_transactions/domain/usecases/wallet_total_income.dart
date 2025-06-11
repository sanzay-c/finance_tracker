import 'package:finance_tracker/common/features/add_transactions/domain/repo/transaction_repo.dart';

class WalletTotalIncome {
  final TransactionRepo repository;

  WalletTotalIncome({required this.repository});

  Future<double> call(String walletId) async {
    final transactions = await repository.getTransactionsByWalletIdAndType(
      walletId: walletId,
      transactionType: 'income',
    );

    double total = 0;
    for (var t in transactions) {
      total += t.amount ?? 0;
    }
    return total;
  }
}
