import 'package:finance_tracker/features/login/data/datasource/auth_remote_datasource.dart';
import 'package:finance_tracker/features/login/domain/repository/auth_repository.dart';

class LoginAuthRepositoryImpl implements LoginAuthRepository {
  final LoginAuthRemoteDatasource remoteDatasource;

  LoginAuthRepositoryImpl(this.remoteDatasource);

  @override
  Future<void> loginUserWithEmailAndPassword(String email, String password) {
    return remoteDatasource.loginUserWithEmailAndPassword(email, password);
  }
}
