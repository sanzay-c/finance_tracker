import 'dart:developer';
//log print garna ko lagi tala yo dart:developer import garna parxa
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  //google sign in garna ko lagi function
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      // yesma tyo GoogleSignIn() bhitra client id rakhyo vane bujhne ki web ma run gareko vanera natra vane android ma run gareko bujhne
      final googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );
      return await _auth.signInWithCredential(cred);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  //create user or sign up function
  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      exceptionHandler(e.code);
    } catch (e, stackTrace) {
      log(
        'SignUpError: $e',
        error: e,
        stackTrace: stackTrace, // helpful for debugging
      );
    }
    return null;
  }

  //sign in user  or login function
  Future<User?> loginUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      exceptionHandler(e.code);
      throw e; // RE-THROW so that caller knows!
    } catch (e, stackTrace) {
      log(
        'LoginError: $e',
        name: 'LoginError', // optional: name your log
        error: e,
        stackTrace: stackTrace, // helpful for debugging
      );
      throw e; // Optionally also throw here!
    }
  }

  //forgot password ko function
  Future<void> sendEmailVerificationLink() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  //send password reset link
  Future<void> sendPasswordResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  //sign out or logout function
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e, stackTrace) {
      log(
        'LogOutError: $e',
        name: 'LogOutError',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}

exceptionHandler(String code) {
  switch (code) {
    case "invalid-credentials":
      log("Your login credentials are invalid");
    case "weak password":
      log("Your password must be at least 8 characters");
    case "email-already-in-use":
      log("User Already Exists");
    default:
      log("Something went wrong");
  }
}
