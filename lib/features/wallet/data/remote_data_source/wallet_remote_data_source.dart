import 'package:finance_tracker/features/wallet/data/models/wallet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletRemoteDataSource {
  final FirebaseFirestore firestore;

  WalletRemoteDataSource({required this.firestore});

  Future<void> addWallet(WalletModel wallet) async {
    await firestore.collection('wallets').doc(wallet.id).set(wallet.toMap());
  }

  Future<List<WalletModel>> getWallets() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    final snapshot = await firestore
        .collection('wallets')
        .where('uid', isEqualTo: uid)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return WalletModel.fromMap(data);
    }).toList();
  }
}
