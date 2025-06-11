part of 'transaction_bloc.dart';

@immutable
abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class WalletsLoading extends TransactionState {}

class WalletsLoaded extends TransactionState {
  final List<String> wallets;

  WalletsLoaded(this.wallets);
}

class TransactionSubmitting extends TransactionState {}

class TransactionSuccess extends TransactionState {}

class TransactionError extends TransactionState {
  final String message;

  TransactionError(this.message);
}
