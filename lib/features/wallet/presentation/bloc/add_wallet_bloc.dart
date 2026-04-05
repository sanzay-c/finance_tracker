import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:finance_tracker/features/wallet/domain/entities/wallet_entity.dart';
import 'package:finance_tracker/features/wallet/domain/usecases/add_wallet.dart';
import 'package:finance_tracker/features/wallet/domain/usecases/get_wallet.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'add_wallet_event.dart';
part 'add_wallet_state.dart';

class AddWalletBloc extends Bloc<AddWalletEvent, AddWalletState> {
  final AddWallet addWallet;
  final GetWallets getWallets;

  AddWalletBloc({
    required this.addWallet,
    required this.getWallets,
  }) : super(AddWalletInitial()) {
    on<SubmitWalletEvent>(_onSubmitWalletEvent);
    on<FetchWalletsEvent>(_onFetchWalletsEvent);
  }

  FutureOr<void> _onSubmitWalletEvent(
    SubmitWalletEvent event,
    Emitter<AddWalletState> emit,
  ) async {
    try {
      print('📝 Submitting wallet: ${event.name}');
      emit(AddWalletLoading());

      final wallet = WalletEntity(
        id: const Uuid().v4(),
        name: event.name,
        imageUrl: event.imageUrl ?? '',
        amount: 0.0,
        totalExpenses: 0.0,
        totalIncome: 0.0,
        createdAt: DateTime.now(), uid: '',
      );

      await addWallet(wallet);
      print('✅ Wallet added successfully: ${wallet.name}');

      emit(AddWalletSuccess(wallet));
    } catch (e) {
      print('❌ Error adding wallet: $e');
      emit(AddWalletError(errorMessage: 'Error While Adding Wallet: $e'));
    }
  }

  FutureOr<void> _onFetchWalletsEvent(
    FetchWalletsEvent event,
    Emitter<AddWalletState> emit,
  ) async {
    try {
      print('🔍 Fetching wallets...');
      emit(AddWalletLoading());

      final wallets = await getWallets();
      print('📦 Raw wallets from database: ${wallets.length}');
      
      print('📊 Using stored amounts from database:');
      for (var wallet in wallets) {
        print('  - ${wallet.name}: Rs.${wallet.amount} (stored)');
      }
      
      emit(GetWalletsLoaded(wallets));
      print('✅ Wallets loaded successfully');
    } catch (e) {
      print('❌ Error fetching wallets: $e');
      emit(AddWalletError(errorMessage: 'Failed to fetch wallets: $e'));
    }
  }
}