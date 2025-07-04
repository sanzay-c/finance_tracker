class TransactionEntity {
  final String id;
  final String walletId; 
  final String type;
  final String category;
  final DateTime date;
  final double amount;
  final String? description;
  final String? receiptUrl;

  TransactionEntity({
    required this.id,
    required this.walletId, 
    required this.type,
    required this.category,
    required this.date,
    required this.amount,
    this.description,
    this.receiptUrl,
  });
}
