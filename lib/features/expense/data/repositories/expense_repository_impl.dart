import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/features/expense/domain/entities/transaction_entity.dart';
import 'package:finance_tracker/features/expense/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final FirebaseFirestore firestore;

  ExpenseRepositoryImpl(this.firestore);

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    try {
      final data = transaction.toJson();
      data.remove('id'); // Don't include 'id' when creating
      await firestore.collection('transactions').add(data);
    } catch (e) {
      throw Exception('Failed to save transaction: $e');
    }
  }

  @override
  Future<void> updateTransaction(
    String id,
    TransactionEntity transaction,
  ) async {
    final data = transaction.toJson();
    data.remove('id'); // Don't overwrite the document ID field
    await firestore.collection('transactions').doc(id).update(data);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await firestore.collection('transactions').doc(id).delete();
  }
}
