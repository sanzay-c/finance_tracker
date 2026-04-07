import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  StreamSubscription? _walletSubscription;
  StreamSubscription? _transactionSubscription;

  DashboardBloc() : super(DashboardInitial()) {
    on<FetchDashboardDataEvent>(_onFetchDashboardData);
    on<_UpdateDashboardDataEvent>(_onUpdateDashboardData);
  }

  @override
  Future<void> close() {
    _walletSubscription?.cancel();
    _transactionSubscription?.cancel();
    return super.close();
  }

  void _onFetchDashboardData(FetchDashboardDataEvent event, Emitter<DashboardState> emit) {
    emit(DashboardLoading());
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      emit(DashboardError('User not logged in'));
      return;
    }

    _walletSubscription?.cancel();
    _transactionSubscription?.cancel();

    _walletSubscription = FirebaseFirestore.instance
        .collection('wallets')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .listen((walletSnap) {
      FirebaseFirestore.instance
          .collection('transactions')
          .where('uid', isEqualTo: uid)
          .get() 
          .then((transactionSnap) {
        add(_UpdateDashboardDataEvent(walletSnap, transactionSnap));
      });
    });

    _transactionSubscription = FirebaseFirestore.instance
        .collection('transactions')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .listen((transactionSnap) {
       FirebaseFirestore.instance
          .collection('wallets')
          .where('uid', isEqualTo: uid)
          .get()
          .then((walletSnap) {
        add(_UpdateDashboardDataEvent(walletSnap, transactionSnap));
      });
    });
  }

  FutureOr<void> _onUpdateDashboardData(_UpdateDashboardDataEvent event, Emitter<DashboardState> emit) {
    double totalBalance = 0;
    double totalIncome = 0;
    double totalExpense = 0;

    for (var wallet in event.walletSnap.docs) {
      totalBalance += (wallet.data()['amount'] as num).toDouble();
    }

    for (var txn in event.transactionSnap.docs) {
      final data = txn.data();
      final type = data['type'];
      final amount = (data['amount'] as num).toDouble();
      if (type == 'income') {
        totalIncome += amount;
      } else {
        totalExpense += amount;
      }
    }

    emit(DashboardLoaded(
      totalBalance: totalBalance,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
    ));
  }
}

class _UpdateDashboardDataEvent extends DashboardEvent {
  final QuerySnapshot<Map<String, dynamic>> walletSnap;
  final QuerySnapshot<Map<String, dynamic>> transactionSnap;
  _UpdateDashboardDataEvent(this.walletSnap, this.transactionSnap);
}
