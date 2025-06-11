class WalletEntity {
  final String id;
  final String name;
  final String? imageUrl;
  final double amount;

  WalletEntity({
    required this.id,
    required this.name,
    this.imageUrl,
    this.amount = 0,
  });

  WalletEntity copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? amount,
  }) {
    return WalletEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      amount: amount ?? this.amount,
    );
  }
}
