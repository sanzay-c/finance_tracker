import 'package:finance_tracker/features/add-expense/domain/entities/transaction_entity.dart';
import 'package:finance_tracker/features/add-expense/domain/repository/expense_repository.dart';

class AddExpenseUseCase {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  Future<void> execute(TransactionEntity transaction) async {
    await repository.addTransaction(transaction);
  }
}
