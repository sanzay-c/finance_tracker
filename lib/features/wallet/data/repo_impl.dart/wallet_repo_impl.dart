  import 'package:finance_tracker/features/wallet/data/models/wallet_model.dart';
  import 'package:finance_tracker/features/wallet/data/remote_data_source/wallet_remote_data_source.dart';
  import 'package:finance_tracker/features/wallet/domain/entities/wallet_entity.dart';
  import 'package:finance_tracker/features/wallet/domain/repo/wallet_repo.dart';

  class WalletRepositoryImpl implements WalletRepository {
    final WalletRemoteDataSource remoteDataSource;

    WalletRepositoryImpl({required this.remoteDataSource});

    @override
    Future<void> addWallet(WalletEntity wallet) async {
      final model = WalletModel(
        id: wallet.id,
        name: wallet.name,
        imageUrl: wallet.imageUrl,
        totalExpenses: wallet.totalExpenses,
        totalIncome: wallet.totalIncome,
        createdAt: wallet.createdAt,
        amount: wallet.amount, uid: '',
      );
      await remoteDataSource.addWallet(model);
    }

    @override
    Future<List<WalletEntity>> getWallets() async {
      final models = await remoteDataSource.getWallets();
      return models
          .map(
            (model) => WalletEntity(
              id: model.id,
              name: model.name,
              imageUrl: model.imageUrl,
              totalExpenses: model.totalExpenses,
              amount: model.amount,
              totalIncome: model.totalIncome,
              createdAt: model.createdAt, uid: '',
            ),
          )
          .toList();
    }
  }
