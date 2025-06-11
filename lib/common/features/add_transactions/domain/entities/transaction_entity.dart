class TransactionEntity {
  final String id;
  final String type;
  final String wallet;
  final String category;
  final DateTime date;
  final double amount;
  final String? description;
  final String? receiptUrl;

  TransactionEntity({
    required this.id,
    required this.type,
    required this.wallet,
    required this.category,
    required this.date,
    required this.amount,
    this.description,
    this.receiptUrl,
  });
}
