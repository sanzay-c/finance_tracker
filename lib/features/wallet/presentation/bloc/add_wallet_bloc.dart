import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:finance_tracker/features/wallet/domain/entities/wallet_entity.dart';
import 'package:finance_tracker/features/wallet/domain/usecases/add_wallet.dart';
import 'package:finance_tracker/features/wallet/domain/usecases/get_wallet.dart';
import 'package:finance_tracker/features/wallet/domain/usecases/watch_wallets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'add_wallet_event.dart';
part 'add_wallet_state.dart';

class AddWalletBloc extends Bloc<AddWalletEvent, AddWalletState> {
  final AddWallet addWallet;
  final GetWallets getWallets;
  final WatchWallets watchWallets;
  StreamSubscription? _walletSubscription;

  AddWalletBloc({
    required this.addWallet,
    required this.getWallets,
    required this.watchWallets,
  }) : super(AddWalletInitial()) {
    on<SubmitWalletEvent>(_onSubmitWalletEvent);
    on<FetchWalletsEvent>(_onFetchWalletsEvent);
    on<_OnWalletsUpdated>(_onWalletsUpdated);
  }

  @override
  Future<void> close() {
    _walletSubscription?.cancel();
    return super.close();
  }

  FutureOr<void> _onSubmitWalletEvent(
    SubmitWalletEvent event,
    Emitter<AddWalletState> emit,
  ) async {
    try {
      emit(AddWalletLoading());

      final wallet = WalletEntity(
        id: event.id,
        name: event.name,
        imageUrl: event.imageUrl ?? '',
        amount: event.amount,
        totalExpenses: 0.0,
        totalIncome: 0.0,
        createdAt: DateTime.now(),
        uid: FirebaseAuth.instance.currentUser?.uid ?? '',
      );

      await addWallet(wallet);
      emit(AddWalletSuccess(wallet));
    } catch (e) {
      emit(AddWalletError(errorMessage: 'Error While Adding Wallet: $e'));
    }
  }

  void _onFetchWalletsEvent(
    FetchWalletsEvent event,
    Emitter<AddWalletState> emit,
  ) {
    emit(AddWalletLoading());
    
    _walletSubscription?.cancel();
    _walletSubscription = watchWallets().listen((wallets) {
      add(_OnWalletsUpdated(wallets));
    }, onError: (error) {
      add(_OnWalletsUpdated([])); 
    });
  }

  FutureOr<void> _onWalletsUpdated(
    _OnWalletsUpdated event,
    Emitter<AddWalletState> emit,
  ) {
    emit(GetWalletsLoaded(event.wallets));
  }
}