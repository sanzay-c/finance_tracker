  import 'package:finance_tracker/features/transactions/data/datasources/transaction_remote_datasource.dart';
  import 'package:finance_tracker/features/transactions/domain/repo/transaction_repo.dart';

  import '../../domain/entities/transaction_entity.dart';
  import '../models/transaction_model.dart';

  class TransactionRepositoryImpl implements TransactionRepository {
    final TransactionRemoteDataSource remoteDataSource;

    TransactionRepositoryImpl(this.remoteDataSource);

    @override
    Future<void> addTransaction(TransactionEntity transaction) {
      final model = TransactionModel.fromEntity(transaction);
      return remoteDataSource.addTransaction(model);
    }
  }
