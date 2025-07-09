part of 'fetch_transaction_bloc.dart';

@immutable
sealed class FetchTransactionState {}

final class FetchTransactionInitial extends FetchTransactionState {}

class FetchTransactionLoading extends FetchTransactionState {}

class FetchTransactionLoaded extends FetchTransactionState {
  final List<TransactionEntity> transactions;

  FetchTransactionLoaded(this.transactions);
}

class FetchTransactionError extends FetchTransactionState {
  final String message;

  FetchTransactionError(this.message);
}
