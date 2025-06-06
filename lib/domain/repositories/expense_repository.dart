// lib/domain/repositories/expense_repository.dart
import '../entities/transaction_entity.dart';

abstract class ExpenseRepository {
  Future<void> addTransaction(TransactionEntity transaction);
}
