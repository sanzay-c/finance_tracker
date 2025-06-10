import 'package:equatable/equatable.dart';
import 'package:finance_tracker/features/expense/domain/entities/transaction_entity.dart';

abstract class ExpenseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddExpenseRequested extends ExpenseEvent {
  final TransactionEntity transaction;

  AddExpenseRequested(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class UpdateExpenseRequested extends ExpenseEvent {
  final String id;
  final TransactionEntity transaction;

  UpdateExpenseRequested(this.id, this.transaction);

  @override
  List<Object?> get props => [id, transaction];
}

class DeleteExpenseRequested extends ExpenseEvent {
  final String id;

  DeleteExpenseRequested(this.id);

  @override
  List<Object?> get props => [id];
}
