import 'package:finance_tracker/common/features/add_transactions/domain/entities/transaction_entity.dart';
import 'package:finance_tracker/common/features/add_transactions/domain/repo/transaction_repo.dart';

class CreatTransactionUsecase {
  final TransactionRepo transactionRepo;

  CreatTransactionUsecase({required this.transactionRepo});

  Future<void> call(TransactionEntity transaction) async {
    return await transactionRepo.addTransaction(transaction);
  }
}
