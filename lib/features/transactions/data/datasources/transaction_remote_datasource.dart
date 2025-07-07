import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<void> addTransaction(TransactionModel transaction);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final FirebaseFirestore firestore;

  TransactionRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await firestore
        .collection('transactions')
        .doc(transaction.id)
        .set(transaction.toMap());
  }
}
