import 'package:finance_tracker/common/features/wallet/domain/entities/wallet_entity.dart';
import 'package:finance_tracker/common/features/wallet/domain/repo/wallet_repo.dart';

class AddWallet {
  final WalletRepository repository;

  AddWallet({required this.repository});

  Future<void> call(WalletEntity wallet) async {
    await repository.addWallet(wallet);
  }
}
