import 'package:firebase_auth/firebase_auth.dart';

class SignUpAuthRemoteDatasource {
  final FirebaseAuth _firebaseAuth;

  SignUpAuthRemoteDatasource(this._firebaseAuth);

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
