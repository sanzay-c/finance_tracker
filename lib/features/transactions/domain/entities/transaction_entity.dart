class TransactionEntity {
  final String id;
  final String type;
  final String walletId;
  final String? category;
  final DateTime date;
  final double amount;
  final String? description;

  TransactionEntity({
    required this.id,
    required this.type,
    required this.walletId,
    this.category,
    required this.date,
    required this.amount,
    this.description,
  });

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

  factory TransactionEntity.fromMap(Map<String, dynamic> map) {
    return TransactionEntity(
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
