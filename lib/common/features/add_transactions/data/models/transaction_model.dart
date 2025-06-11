import 'package:finance_tracker/common/features/add_transactions/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.id,
    required super.type,
    required super.wallet,
    required super.category,
    required super.date,
    required super.amount,
    super.description,
    super.receiptUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'wallet': wallet,
      'category': category,
      'date': date.toIso8601String(),
      'amount': amount,
      'description': description,
      'receiptUrl': receiptUrl,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      type: json['type'] as String,
      wallet: json['wallet'] as String,
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      receiptUrl: json['receiptUrl'] as String?,
    );
  }

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      type: entity.type,
      wallet: entity.wallet,
      category: entity.category,
      date: entity.date,
      amount: entity.amount,
      description: entity.description,
      receiptUrl: entity.receiptUrl,
    );
  }
}
