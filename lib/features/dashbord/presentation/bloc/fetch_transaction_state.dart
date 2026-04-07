part of 'fetch_transaction_bloc.dart';

@immutable
sealed class FetchTransactionState {}

final class FetchTransactionInitial extends FetchTransactionState {}

class FetchTransactionLoading extends FetchTransactionState {}

class FetchTransactionLoaded extends FetchTransactionState {
  final List<TransactionEntity> transactions;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  FetchTransactionLoaded({
    required this.transactions,
    this.lastDocument,
    this.hasMore = true,
  });
}

class FetchTransactionError extends FetchTransactionState {
  final String message;

  FetchTransactionError(this.message);
}
