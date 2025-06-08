import 'package:finance_tracker/features/add-expense/domain/entities/transaction_entity.dart';

abstract class ExpenseRepository {
  Future<void> addTransaction(TransactionEntity transaction);
}
