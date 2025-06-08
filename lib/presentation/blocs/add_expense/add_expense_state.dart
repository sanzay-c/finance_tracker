import 'package:equatable/equatable.dart';

abstract class ExpenseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseSuccess extends ExpenseState {}

class ExpenseFailure extends ExpenseState {
  final String error;

  ExpenseFailure(this.error);

  @override
  List<Object?> get props => [error];
}
