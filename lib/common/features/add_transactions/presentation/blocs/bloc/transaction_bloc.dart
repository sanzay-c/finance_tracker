import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/common/features/add_transactions/presentation/blocs/bloc/transaction_event.dart';
import 'package:meta/meta.dart';

part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<LoadWalletsEvent>(_onLoadWallets);
    on<SubmitTransactionEvent>(_onSubmitTransaction);
  }

  Future<void> _onLoadWallets(
    LoadWalletsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(WalletsLoading());
    try {
      final snapshot = await FirebaseFirestore.instance.collection('wallets').get();
      final walletNames = snapshot.docs.map((doc) => doc['name'] as String).toList();
      emit(WalletsLoaded(walletNames));
    } catch (e) {
      emit(TransactionError('Failed to load wallets'));
    }
  }

  Future<void> _onSubmitTransaction(
    SubmitTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionSubmitting());
    try {
      await FirebaseFirestore.instance.collection('transactions').add({
        'type': event.transactionType,
        'wallet': event.wallet,
        'category': event.category,
        'date': event.date,
        'amount': event.amount,
        'description': event.description,
        'createdAt': Timestamp.now(),
      });
      emit(TransactionSuccess());
    } catch (e) {
      emit(TransactionError('Submission failed'));
    }
  }
}