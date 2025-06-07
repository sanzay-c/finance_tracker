import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/login_user_usecase.dart';
import 'login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUserUseCase loginUserUseCase;

  LoginCubit(this.loginUserUseCase) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    try {
      emit(LoginLoading());
      await loginUserUseCase.call(email, password);
      emit(LoginSuccess());
    } catch (e) {
      String errorMessage = "An error occurred.";
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          errorMessage = "You entered wrong email or password.";
        } else {
          errorMessage = e.message ?? "An unknown error occurred.";
        }
      }
      emit(LoginFailure(errorMessage));
    }
  }
}
