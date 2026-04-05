import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_tracker/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:meta/meta.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final AddTransactionUseCase addTransactionUseCase;

  TransactionBloc(this.addTransactionUseCase) : super(TransactionInitial()) {
    on<AddTransactionEvent>(_onAddTransaction);
  }

  Future<void> _onAddTransaction(
    AddTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      await addTransactionUseCase(event.transaction);

      final transaction = event.transaction;
      final walletRef = FirebaseFirestore.instance
          .collection('wallets')
          .doc(transaction.walletId);

      await FirebaseFirestore.instance.runTransaction((txn) async {
        final snapshot = await txn.get(walletRef);

        if (!snapshot.exists) throw Exception('Wallet not found');

        final currentAmount = (snapshot['amount'] ?? 0).toDouble();
        final currentIncome = (snapshot['totalIncome'] ?? 0).toDouble();
        final currentExpenses = (snapshot['totalExpenses'] ?? 0).toDouble();

        final amount = transaction.amount;
        final isIncome = transaction.type == 'income';

        final newAmount =
            isIncome ? currentAmount + amount : currentAmount - amount;
        
        if (!isIncome && newAmount < 0) {
          throw Exception('Insufficient balance in this wallet (Current: Rs. $currentAmount)');
        }

        final newIncome = isIncome ? currentIncome + amount : currentIncome;
        final newExpenses =
            isIncome ? currentExpenses : currentExpenses + amount;

        txn.update(walletRef, {
          'amount': newAmount,
          'totalIncome': newIncome,
          'totalExpenses': newExpenses,
        });
      });

      emit(TransactionSuccess());
    } catch (e) {
      emit(TransactionFailure(e.toString()));
    }
  }
}
