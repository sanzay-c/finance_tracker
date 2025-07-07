import 'package:finance_tracker/features/transactions/domain/repo/transaction_repo.dart';

import '../entities/transaction_entity.dart';

class AddTransactionUseCase {
  final TransactionRepository repository;

  AddTransactionUseCase(this.repository);

  Future<void> call(TransactionEntity transaction) {
    return repository.addTransaction(transaction);
  }
}
