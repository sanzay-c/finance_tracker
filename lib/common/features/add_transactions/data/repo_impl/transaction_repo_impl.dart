import 'package:finance_tracker/common/features/add_transactions/data/data_remote_source/transaction_remote_data_source.dart';
import 'package:finance_tracker/common/features/add_transactions/domain/entities/transaction_entity.dart';
import 'package:finance_tracker/common/features/add_transactions/domain/repo/transaction_repo.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepo {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    await remoteDataSource.addTransaction(model);
  }
  
 @override
  Future<List<TransactionModel>> getTransactionsByWalletIdAndType({
    required String walletId,
    required String transactionType,
  }) async {
    return await remoteDataSource.getTransactionsByWalletIdAndType(
      walletId: walletId,
      transactionType: transactionType,
    );
  }
}
