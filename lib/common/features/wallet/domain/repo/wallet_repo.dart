import 'package:finance_tracker/common/features/wallet/domain/entities/wallet_entity.dart';

abstract class WalletRepository {
  Future<List<WalletEntity>> getWallets();
  Future<void> addWallet(WalletEntity wallet);
}
