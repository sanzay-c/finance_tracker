import 'package:finance_tracker/common/features/wallet/data/models/waller_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class WalletRemoteDataSource {
  final FirebaseFirestore firestore;

  WalletRemoteDataSource({required this.firestore});

  Future<void> addWallet(WalletModel wallet) async {
    await firestore.collection('wallets').doc(wallet.id).set(wallet.toMap());
  }

  Future<List<WalletModel>> getWallets() async {
    final snapshot = await firestore.collection('wallets').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return WalletModel.fromMap(data);
    }).toList();
  }
}
