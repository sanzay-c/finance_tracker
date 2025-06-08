import 'package:finance_tracker/domain/entities/transaction_entity.dart';
import 'package:finance_tracker/domain/repositories/expense_repository.dart';

class UpdateExpenseUseCase {
  final ExpenseRepository repository;

  UpdateExpenseUseCase(this.repository);

  Future<void> execute(String id, TransactionEntity transaction) {
    return repository.updateTransaction(id, transaction);
  }
}
