// lib/domain/repositories/expense_repository.dart
import '../entities/transaction_entity.dart';

abstract class ExpenseRepository {
  Future<void> addTransaction(TransactionEntity transaction);
  Future<void> updateTransaction(
    String id,
    TransactionEntity transaction,
  ); // New
  Future<void> deleteTransaction(String id); // New
}
