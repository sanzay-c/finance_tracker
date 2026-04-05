import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletTotalIncome {
  final FirebaseFirestore firestore;

  WalletTotalIncome({required this.firestore, required repository});

  Future<double> call(String walletId) async {
    final snapshot = await firestore
        .collection('transactions')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('walletId', isEqualTo: walletId)
        .get();

    double total = 0.0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] ?? 0).toDouble();
      final type = data['type'];

      if (type == 'income') {
        total += amount;
      } else if (type == 'expense') {
        total -= amount;
      }
    }

    return total;
  }
}
