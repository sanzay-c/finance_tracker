import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<FetchDashboardDataEvent>(_onFetchDashboardData);
  }

  FutureOr<void> _onFetchDashboardData(FetchDashboardDataEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(DashboardError('User not logged in'));
        return;
      }

      final walletSnap = await FirebaseFirestore.instance
          .collection('wallets')
          .where('uid', isEqualTo: uid)
          .get();
      final transactionSnap = await FirebaseFirestore.instance
          .collection('transactions')
          .where('uid', isEqualTo: uid)
          .get();

      double totalBalance = 0;
      double totalIncome = 0;
      double totalExpense = 0;

      for (var wallet in walletSnap.docs) {
        totalBalance += (wallet.data()['amount'] as num).toDouble();
      }

      for (var txn in transactionSnap.docs) {
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
    } catch (e) {
      emit(DashboardError('Failed to load dashboard data'));
    }
  }

}
