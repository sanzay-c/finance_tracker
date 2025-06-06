// lib/data/repositories/expense_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final FirebaseFirestore firestore;

  ExpenseRepositoryImpl(this.firestore);

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    try {
      final data = {
        'type': transaction.type,
        'date': transaction.date.toIso8601String(),
        'category': transaction.category,
        'description': transaction.description,
        'total': transaction.total,
      };
      await firestore.collection('transactions').add(data);
    } catch (e) {
      throw Exception('Failed to save transaction: $e');
    }
  }
}
