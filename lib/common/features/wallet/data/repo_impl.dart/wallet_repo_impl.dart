import 'package:finance_tracker/common/features/wallet/data/models/waller_model.dart';
import 'package:finance_tracker/common/features/wallet/data/remote_data_source/wallet_remote_data_source.dart';
import 'package:finance_tracker/common/features/wallet/domain/entities/wallet_entity.dart';
import 'package:finance_tracker/common/features/wallet/domain/repo/wallet_repo.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addWallet(WalletEntity wallet) async {
    final model = WalletModel(id: wallet.id, name: wallet.name, imageUrl: wallet.imageUrl);
    await remoteDataSource.addWallet(model);
  }
  
 @override
  Future<List<WalletEntity>> getWallets() async {
    final models = await remoteDataSource.getWallets();
    return models.map((model) => WalletEntity(
      id: model.id,
      name: model.name,
      imageUrl: model.imageUrl,
    )).toList();
  }
}
