import 'package:equatable/equatable.dart';
import 'package:finance_tracker/features/add-expense/domain/entities/transaction_entity.dart';

abstract class AddExpenseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddExpenseRequested extends AddExpenseEvent {
  final TransactionEntity transaction;

  AddExpenseRequested(this.transaction);

  @override
  List<Object?> get props => [transaction];
}
