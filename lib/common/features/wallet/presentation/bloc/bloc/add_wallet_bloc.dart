import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:finance_tracker/common/features/add_transactions/domain/usecases/wallet_total_income.dart';
import 'package:finance_tracker/common/features/wallet/domain/entities/wallet_entity.dart';
import 'package:finance_tracker/common/features/wallet/domain/usecases/add_wallet.dart';
import 'package:finance_tracker/common/features/wallet/domain/usecases/get_wallet.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'add_wallet_event.dart';
part 'add_wallet_state.dart';

class AddWalletBloc extends Bloc<AddWalletEvent, AddWalletState> {
  final AddWallet addWallet;
  final GetWallets getWallets;
  final WalletTotalIncome walletTotalIncome;

  AddWalletBloc({
    required this.addWallet,
    required this.getWallets,
    required this.walletTotalIncome,
  }) : super(AddWalletInitial()) {
    on<SubmitWalletEvent>(_onSubmitWalletEvent);
    on<FetchWalletsEvent>(_onFetchWalletsEvent);
  }

  FutureOr<void> _onSubmitWalletEvent(
    SubmitWalletEvent event,
    Emitter<AddWalletState> emit,
  ) async {
    try {
      emit(AddWalletLoading());
      final wallet = WalletEntity(
        id: const Uuid().v4(),
        name: event.name,
        imageUrl: event.imageUrl,
      );
      await addWallet(wallet);
      emit(AddWalletSuccess(wallet));
    } catch (e) {
      emit(AddWalletError(errorMessage: 'Error While Adding Wallet: $e'));
    }
  }

  FutureOr<void> _onFetchWalletsEvent(
    FetchWalletsEvent event,
    Emitter<AddWalletState> emit,
  ) async {
    try {
      emit(AddWalletLoading());

      final wallets = await getWallets();

      List<WalletEntity> walletsWithAmounts = [];

      for (var wallet in wallets) {
        final totalAmount = await walletTotalIncome(wallet.id);
        final walletWithAmount = wallet.copyWith(amount: totalAmount);
        walletsWithAmounts.add(walletWithAmount);
      }

      emit(GetWalletsLoaded(walletsWithAmounts));
    } catch (e) {
      emit(AddWalletError(errorMessage: 'Failed to fetch wallets: $e'));
    }
  }
}
