import 'package:finance_tracker/features/sign-up/domain/repository/auth_repository.dart';

class SignupUserUsecase {
  final SignUpAuthRepository repository;

  SignupUserUsecase(this.repository);

  Future<void> call(String email, String password) {
    return repository.createUserWithEmailAndPassword(email, password);
  }
}
