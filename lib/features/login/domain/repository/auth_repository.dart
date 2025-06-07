abstract class LoginAuthRepository {
  Future<void> loginUserWithEmailAndPassword(String email, String password);
}
