import 'package:finance_tracker/core/utils/date_parser.dart';
import 'package:finance_tracker/features/wallet/domain/entities/wallet_entity.dart';

class WalletModel extends WalletEntity {
  WalletModel({
    required super.id,
    required super.name,
    required super.totalExpenses,
    required super.totalIncome,
    required super.createdAt,
    required super.amount,
    required super.imageUrl, 
    required super.uid,
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
      'uid': uid,
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      totalExpenses: map['totalExpenses'] ?? 0,
      totalIncome: (map['totalIncome'] ?? 0).toDouble(),
      createdAt: DateParser.parse(map['createdAt']),
      amount: (map['amount'] ?? 0).toDouble(),
      uid: map['uid'] ?? '',
    );
  }
}
