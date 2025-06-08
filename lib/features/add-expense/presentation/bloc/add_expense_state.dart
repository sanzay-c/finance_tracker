import 'package:equatable/equatable.dart';

abstract class AddExpenseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddExpenseInitial extends AddExpenseState {}

class AddExpenseLoading extends AddExpenseState {}

class AddExpenseSuccess extends AddExpenseState {}

class AddExpenseFailure extends AddExpenseState {
  final String error;

  AddExpenseFailure(this.error);

  @override
  List<Object?> get props => [error];
}
