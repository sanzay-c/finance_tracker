abstract class TransactionEvent {}

class LoadWalletsEvent extends TransactionEvent {}

class SubmitTransactionEvent extends TransactionEvent {
  final String transactionType;
  final String wallet;
  final String? category;
  final DateTime date;
  final double amount;
  final String? description;

  SubmitTransactionEvent({
    required this.transactionType,
    required this.wallet,
    this.category,
    required this.date,
    required this.amount,
    this.description,
  });
}
