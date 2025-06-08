import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/features/add-expense/domain/entities/transaction_entity.dart';
import 'package:finance_tracker/features/add-expense/domain/repository/expense_repository.dart';
import 'package:finance_tracker/helper/notification/notification_warning_function.dart';

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
        'userName': transaction.userName,
        'userEmail': transaction.userEmail,
      };
      // Add transaction to Firestore
      await firestore.collection('transactions').add(data);

      // Query all transactions for the user to calculate totals
      final querySnapshot =
          await firestore
              .collection('transactions')
              .where('userEmail', isEqualTo: transaction.userEmail)
              .get();

      double totalIncome = 0;
      double totalExpense = 0;

      for (var doc in querySnapshot.docs) {
        final trans = doc.data();
        final type = trans['type'] as String?;
        final total = trans['total'] as num? ?? 0;

        if (type?.toLowerCase() == 'income') {
          totalIncome += total.toDouble();
        } else if (type?.toLowerCase() == 'expense') {
          totalExpense += total.toDouble();
        }
      }

      // Show notification if expenses exceed income
      if (totalExpense > totalIncome) {
        await showExpenseWarningNotification();
      }
    } catch (e) {
      throw Exception('Failed to save transaction: $e');
    }
  }
}
