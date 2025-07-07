part of 'transaction_bloc.dart';

@immutable
abstract class TransactionEvent {}

class AddTransactionEvent extends TransactionEvent {
  final TransactionEntity transaction;

  AddTransactionEvent(this.transaction);
}

