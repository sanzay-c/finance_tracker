import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/core/utils/date_parser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finance_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:meta/meta.dart';

part 'fetch_transaction_event.dart';
part 'fetch_transaction_state.dart';

class FetchTransactionBloc extends Bloc<FetchTransactionEvent, FetchTransactionState> {
  FetchTransactionBloc() : super(FetchTransactionInitial()) {
    on<FetchTransactionsEvent>(_onFetchTransactionsEvent);
  }

  FutureOr<void> _onFetchTransactionsEvent(FetchTransactionsEvent event, Emitter<FetchTransactionState> emit) async {
    emit(FetchTransactionLoading());
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(FetchTransactionError("User not logged in"));
        return;
      }
      
      final snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('uid', isEqualTo: uid)
          .orderBy('date', descending: true)
          .limit(5)
          .get();

      final transactions = snapshot.docs.map((doc) {
        final data = doc.data();
        return TransactionEntity(
          id: data['id'],
          type: data['type'],
          walletId: data['walletId'],
          category: data['category'],
          date: DateParser.parse(data['date']),
          amount: (data['amount'] as num).toDouble(),
          description: data['description'],
        );
      }).toList();

      emit(FetchTransactionLoaded(transactions));
    } catch (e) {
      emit(FetchTransactionError("Failed to load transactions: $e"));
    }
  }
}
