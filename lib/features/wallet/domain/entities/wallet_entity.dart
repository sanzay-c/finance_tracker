class WalletEntity {
  final String id;
  final String name;
  final String imageUrl;
  final double amount;
  final double totalExpenses;
  final double totalIncome;
  final DateTime createdAt;
  
  WalletEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.amount,
    required this.totalExpenses,
    required this.totalIncome,
    required this.createdAt,
  });

  WalletEntity copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? amount,
    double? totalExpenses,
    double? totalIncome,
    DateTime? createdAt,
  }) {
    return WalletEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      amount: amount ?? this.amount,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      totalIncome: totalIncome ?? this.totalIncome,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
