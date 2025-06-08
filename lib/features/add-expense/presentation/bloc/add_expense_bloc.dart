import 'package:finance_tracker/features/add-expense/domain/usecase/add_expense_usecase.dart';
import 'package:finance_tracker/features/add-expense/presentation/bloc/add_expense_event.dart';
import 'package:finance_tracker/features/add-expense/presentation/bloc/add_expense_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final AddExpenseUseCase addExpenseUseCase;

  AddExpenseBloc(this.addExpenseUseCase) : super(AddExpenseInitial()) {
    on<AddExpenseRequested>((event, emit) async {
      print("🚀 AddExpenseRequested received in BLoC");
      emit(AddExpenseLoading());
      try {
        await addExpenseUseCase.execute(event.transaction);
        print("🎉 AddExpenseUseCase success");
        emit(AddExpenseSuccess());
      } catch (e) {
        print("🔥 AddExpenseUseCase failed: $e");
        emit(AddExpenseFailure(e.toString()));
      }
    });
  }
}
