// lib/domain/usecases/add_expense_use_case.dart
import '../entities/transaction_entity.dart';
import '../repositories/expense_repository.dart';

class AddExpenseUseCase {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  Future<void> execute(TransactionEntity transaction) async {
    await repository.addTransaction(transaction);
  }
}
