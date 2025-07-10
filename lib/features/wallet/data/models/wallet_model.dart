import 'package:finance_tracker/features/wallet/domain/entities/wallet_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletModel extends WalletEntity {
  WalletModel({
    required super.id,
    required super.name,
    required super.totalExpenses,
    required super.totalIncome,
    required super.createdAt,
    required super.amount,
    required super.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'totalExpenses': totalExpenses,
      'totalIncome': totalIncome,
      'createdAt': createdAt.toIso8601String(),
      'amount': amount, 
      'uid': FirebaseAuth.instance.currentUser?.uid,
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      totalExpenses: map['totalExpenses'] ?? 0,
      totalIncome: map['totalIncome'] ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      amount: (map['amount'] ?? 0).toDouble(), 
    );
  }
}
