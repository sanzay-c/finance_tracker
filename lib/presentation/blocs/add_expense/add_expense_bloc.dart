import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_expense_event.dart';
import 'add_expense_state.dart';
import 'package:finance_tracker/domain/usecases/add_expense_usecase.dart';

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
