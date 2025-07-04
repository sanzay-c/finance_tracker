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
  // final WalletTotalIncome walletTotalIncome;

  AddWalletBloc({
    required this.addWallet,
    required this.getWallets,
    // required this.walletTotalIncome,
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

      // Create new WalletEntity with provided info
      final wallet = WalletEntity(
        id: const Uuid().v4(),
        name: event.name,
        imageUrl: event.imageUrl ?? '',
        amount: 0.0,
        totalExpenses: 0.0,
        totalIncome: 0.0,
        createdAt: DateTime.now(),
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
      
      // Option 1: Use stored amount directly (Quick Fix)
      print('📊 Using stored amounts from database:');
      for (var wallet in wallets) {
        print('  - ${wallet.name}: Rs.${wallet.amount} (stored)');
      }
      
      emit(GetWalletsLoaded(wallets));
      print('✅ Wallets loaded successfully');
      
      /* 
      // Option 2: Calculate amounts dynamically (Original approach - only use if you need calculated values)
      final walletsWithAmounts = <WalletEntity>[];

      for (var wallet in wallets) {
        print('💰 Calculating total for wallet: ${wallet.name} (ID: ${wallet.id})');
        
        final totalAmount = await walletTotalIncome(wallet.id);
        print('  - Total amount calculated: $totalAmount');
        
        // Use calculated amount if > 0, otherwise use stored amount
        final finalAmount = totalAmount > 0 ? totalAmount : wallet.amount;
        final updatedWallet = wallet.copyWith(amount: finalAmount);
        walletsWithAmounts.add(updatedWallet);
        
        print('  - Final wallet amount: ${updatedWallet.amount}');
      }

      print('📊 Final wallets with amounts: ${walletsWithAmounts.length}');
      for (var wallet in walletsWithAmounts) {
        print('  - ${wallet.name}: Rs.${wallet.amount}');
      }

      emit(GetWalletsLoaded(walletsWithAmounts));
      print('✅ Wallets loaded successfully');
      */
    } catch (e) {
      print('❌ Error fetching wallets: $e');
      emit(AddWalletError(errorMessage: 'Failed to fetch wallets: $e'));
    }
  }
}