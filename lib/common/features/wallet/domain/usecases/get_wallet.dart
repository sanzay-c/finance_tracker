import 'package:finance_tracker/common/features/wallet/domain/entities/wallet_entity.dart';
import 'package:finance_tracker/common/features/wallet/domain/repo/wallet_repo.dart';

class GetWallets {
  final WalletRepository repository;

  GetWallets({required this.repository});


  Future<List<WalletEntity>> call() async {
    return await repository.getWallets();
  }
}
