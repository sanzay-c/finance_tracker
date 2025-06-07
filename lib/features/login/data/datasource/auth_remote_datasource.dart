import 'package:firebase_auth/firebase_auth.dart';

class LoginAuthRemoteDatasource {
  final FirebaseAuth _firebaseAuth;

  LoginAuthRemoteDatasource(this._firebaseAuth);

  Future<void> loginUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
