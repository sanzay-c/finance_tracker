import 'package:finance_tracker/features/add_transactions/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.id,
    required super.walletId, 
    required super.type,
    required super.category,
    required super.date,
    required super.amount,
    super.description,
    super.receiptUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'walletId': walletId,
      'type': type,
      'category': category,
      'date': date.toIso8601String(),
      'amount': amount,
      'description': description,
      'receiptUrl': receiptUrl,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      walletId: json['walletId'],
      type: json['type'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'],
      receiptUrl: json['receiptUrl'],
    );
  }

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      walletId: entity.walletId,
      type: entity.type,
      category: entity.category,
      date: entity.date,
      amount: entity.amount,
      description: entity.description,
      receiptUrl: entity.receiptUrl,
    );
  }
}
