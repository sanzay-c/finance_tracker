part of 'add_wallet_bloc.dart';

@immutable
abstract class AddWalletState {}

final class AddWalletInitial extends AddWalletState {}

final class AddWalletLoading extends AddWalletState {}

final class AddWalletSuccess extends AddWalletState {
  final WalletEntity wallet;

  AddWalletSuccess(this.wallet);
}

class GetWalletsLoaded extends AddWalletState {
  final List<WalletEntity> wallets;

  GetWalletsLoaded(this.wallets);
}

final class AddWalletError extends AddWalletState {
  final String errorMessage;

  AddWalletError({required this.errorMessage});
}
