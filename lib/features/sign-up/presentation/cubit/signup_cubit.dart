import 'package:bloc/bloc.dart';
import 'package:finance_tracker/features/sign-up/domain/usecase/signup_user_usecase.dart';
import 'package:meta/meta.dart';
part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupUserUsecase signupUserUsecase;
  SignupCubit(this.signupUserUsecase) : super(SignupInitial());

  Future<void> signup(String username, String email, String password) async {
    try {
      emit(SignupLoading());

      // Simulate API call or add your signup logic here
      // await Future.delayed(Duration(seconds: 2));

      await signupUserUsecase(email, password); // REAL call to Firebase

      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
