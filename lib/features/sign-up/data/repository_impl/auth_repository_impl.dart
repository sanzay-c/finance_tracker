import 'package:finance_tracker/features/sign-up/data/datasource/auth_remote_datasource.dart';
import 'package:finance_tracker/features/sign-up/domain/repository/auth_repository.dart';

class SignUpAuthRepositoryImpl implements SignUpAuthRepository {
  final SignUpAuthRemoteDatasource remoteDatasource;

  SignUpAuthRepositoryImpl(this.remoteDatasource);

  @override
  Future<void> createUserWithEmailAndPassword(String email, String password) {
    return remoteDatasource.createUserWithEmailAndPassword(email, password);
  }
}
