class TransactionEntity {
  final String? id;
  final String type; // Expense or Income
  final DateTime date;
  final String? category; // Optional for Income
  final String? description;
  final double total;
  final String? userName;
  final String? userEmail;

  TransactionEntity({
    this.id,
    required this.type,
    required this.date,
    this.category,
    this.description,
    required this.total,
    this.userName,
    this.userEmail,
  });

  /// Convert a `TransactionEntity` to JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'date': date.toIso8601String(),
      'category': category,
      'description': description,
      'total': total,
      'userName': userName,
      'userEmail': userEmail,
    };
  }

  /// Create a `TransactionEntity` from JSON (Map)
  factory TransactionEntity.fromJson(Map<String, dynamic> json, [String? id]) {
    return TransactionEntity(
      id: id ?? json['id'],
      type: json['type'],
      date: DateTime.parse(json['date']),
      category: json['category'],
      description: json['description'],
      total: (json['total'] as num).toDouble(),
      userName: json['userName'],
      userEmail: json['userEmail'],
    );
  }
}
