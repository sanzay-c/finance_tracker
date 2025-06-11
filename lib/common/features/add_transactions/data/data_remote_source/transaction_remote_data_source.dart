import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<void> addTransaction(TransactionModel transaction);

  Future<List<TransactionModel>> getTransactionsByWalletIdAndType({
    required String walletId,
    required String transactionType,
  });
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final FirebaseFirestore firestore;

  TransactionRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    final docRef = firestore.collection('transactions').doc();
    await docRef.set(transaction.toJson());
  }

  @override
  Future<List<TransactionModel>> getTransactionsByWalletIdAndType({
    required String walletId,
    required String transactionType,
  }) async {
    final snapshot = await firestore
        .collection('transactions')
        .where('walletId', isEqualTo: walletId)
        .where('transactionType', isEqualTo: transactionType)
        .get();

    return snapshot.docs
        .map((doc) => TransactionModel.fromJson(doc.data()))
        .toList();
  }
}
