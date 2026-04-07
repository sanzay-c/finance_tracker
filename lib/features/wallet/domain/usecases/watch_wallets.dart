import 'package:finance_tracker/features/wallet/domain/entities/wallet_entity.dart';
import 'package:finance_tracker/features/wallet/domain/repo/wallet_repo.dart';

class WatchWallets {
  final WalletRepository repository;

  WatchWallets({required this.repository});

  Stream<List<WalletEntity>> call() {
    return repository.watchWallets();
  }
}
