class TransactionEntity {
  final String type; // Expense or Income
  final DateTime date;
  final String? category; // Optional for Income
  final String? description;
  final double total;

  TransactionEntity({
    required this.type,
    required this.date,
    this.category,
    this.description,
    required this.total,
  });
}
