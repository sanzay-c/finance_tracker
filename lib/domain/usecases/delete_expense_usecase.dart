import 'package:finance_tracker/domain/repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository repository;

  DeleteExpenseUseCase(this.repository);

  Future<void> execute(String id) {
    return repository.deleteTransaction(id);
  }
}
