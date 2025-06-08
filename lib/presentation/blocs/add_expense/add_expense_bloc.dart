import 'package:finance_tracker/domain/usecases/add_expense_usecase.dart';
import 'package:finance_tracker/domain/usecases/delete_expense_usecase.dart';
import 'package:finance_tracker/domain/usecases/update_expense_usecase.dart';
import 'package:finance_tracker/presentation/blocs/add_expense/add_expense_event.dart';
import 'package:finance_tracker/presentation/blocs/add_expense/add_expense_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final AddExpenseUseCase addExpenseUseCase;
  final UpdateExpenseUseCase updateExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;

  ExpenseBloc({
    required this.addExpenseUseCase,
    required this.updateExpenseUseCase,
    required this.deleteExpenseUseCase,
  }) : super(ExpenseInitial()) {
    on<AddExpenseRequested>(_onAdd);
    on<UpdateExpenseRequested>(_onUpdate);
    on<DeleteExpenseRequested>(_onDelete);
  }

  Future<void> _onAdd(
    AddExpenseRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      await addExpenseUseCase.execute(event.transaction);
      emit(ExpenseSuccess());
    } catch (e) {
      emit(ExpenseFailure(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateExpenseRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      await updateExpenseUseCase.execute(event.id, event.transaction);
      emit(ExpenseSuccess());
    } catch (e) {
      emit(ExpenseFailure(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteExpenseRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      await deleteExpenseUseCase.execute(event.id);
      emit(ExpenseSuccess());
    } catch (e) {
      emit(ExpenseFailure(e.toString()));
    }
  }
}
