import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/features/sign-up/domain/usecase/signup_user_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupUserUsecase signupUserUsecase;
  SignupCubit(this.signupUserUsecase) : super(SignupInitial());

  Future<void> signup(String username, String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user != null) {
        // await user.updateDisplayName(username);

        // 2️⃣ Save user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': username,
          'email': user.email,
          'createdAt': DateTime.now().toIso8601String(),
        });

        emit(SignupSuccess());

        // await signupUserUsecase(email, password); // REAL call to Firebase
      }
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
