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
  StreamSubscription? _transactionSubscription;

  FetchTransactionBloc() : super(FetchTransactionInitial()) {
    on<FetchTransactionsEvent>(_onFetchTransactionsEvent);
    on<LoadMoreTransactionsEvent>(_onLoadMoreTransactionsEvent);
    on<_OnTransactionsUpdated>(_onTransactionsUpdated);
  }

  @override
  Future<void> close() {
    _transactionSubscription?.cancel();
    return super.close();
  }

  void _onFetchTransactionsEvent(FetchTransactionsEvent event, Emitter<FetchTransactionState> emit) {
    emit(FetchTransactionLoading());
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      emit(FetchTransactionError("User not logged in"));
      return;
    }

    _transactionSubscription?.cancel();
    _transactionSubscription = FirebaseFirestore.instance
        .collection('transactions')
        .where('uid', isEqualTo: uid)
        .orderBy('date', descending: true)
        .limit(20)
        .snapshots()
        .listen((snapshot) {
      add(_OnTransactionsUpdated(snapshot));
    });
  }

  FutureOr<void> _onTransactionsUpdated(_OnTransactionsUpdated event, Emitter<FetchTransactionState> emit) {
    final transactions = _mapSnapshotToTransactions(event.snapshot);
    emit(FetchTransactionLoaded(
      transactions: transactions,
      lastDocument: event.snapshot.docs.isNotEmpty ? event.snapshot.docs.last : null,
      hasMore: event.snapshot.docs.length == 20,
    ));
  }

  FutureOr<void> _onLoadMoreTransactionsEvent(LoadMoreTransactionsEvent event, Emitter<FetchTransactionState> emit) async {
    final currentState = state;
    if (currentState is! FetchTransactionLoaded || !currentState.hasMore) return;

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('uid', isEqualTo: uid)
          .orderBy('date', descending: true)
          .startAfterDocument(currentState.lastDocument!)
          .limit(20)
          .get();

      final newTransactions = _mapSnapshotToTransactions(snapshot);

      emit(FetchTransactionLoaded(
        transactions: [...currentState.transactions, ...newTransactions],
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : currentState.lastDocument,
        hasMore: snapshot.docs.length == 20,
      ));
    } catch (e) {
    }
  }

  List<TransactionEntity> _mapSnapshotToTransactions(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
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
  }
}

class _OnTransactionsUpdated extends FetchTransactionEvent {
  final QuerySnapshot<Map<String, dynamic>> snapshot;
  _OnTransactionsUpdated(this.snapshot);
}
