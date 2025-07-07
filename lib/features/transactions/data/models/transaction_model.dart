import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.id,
    required super.type,
    required super.walletId,
    super.category,
    required super.date,
    required super.amount,
    super.description,
  });

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      type: entity.type,
      walletId: entity.walletId,
      category: entity.category,
      date: entity.date,
      amount: entity.amount,
      description: entity.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'walletId': walletId,
      'category': category,
      'date': date.toIso8601String(),
      'amount': amount,
      'description': description,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      type: map['type'],
      walletId: map['walletId'],
      category: map['category'],
      date: DateTime.parse(map['date']),
      amount: map['amount']?.toDouble() ?? 0.0,
      description: map['description'],
    );
  }
}
