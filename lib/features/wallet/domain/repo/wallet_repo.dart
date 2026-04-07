import 'package:finance_tracker/features/wallet/domain/entities/wallet_entity.dart';

abstract class WalletRepository {
  Future<List<WalletEntity>> getWallets();
  Stream<List<WalletEntity>> watchWallets();
  Future<void> addWallet(WalletEntity wallet);
}
