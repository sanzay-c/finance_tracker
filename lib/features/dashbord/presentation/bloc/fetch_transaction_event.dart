part of 'fetch_transaction_bloc.dart';

@immutable
sealed class FetchTransactionEvent {}

class FetchTransactionsEvent extends FetchTransactionEvent {}

class LoadMoreTransactionsEvent extends FetchTransactionEvent {}
