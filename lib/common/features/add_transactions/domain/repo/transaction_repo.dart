import 'package:finance_tracker/common/features/add_transactions/data/models/transaction_model.dart';
import 'package:finance_tracker/common/features/add_transactions/domain/entities/transaction_entity.dart';

abstract class TransactionRepo {
  Future<void> addTransaction(TransactionEntity transaction);

  Future<List<TransactionModel>> getTransactionsByWalletIdAndType({
    required String walletId,
    required String transactionType,
  });
}
