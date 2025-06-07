abstract class SignUpAuthRepository {
  Future<void> createUserWithEmailAndPassword(String email, String password);
}
