import 'package:finance_tracker/common/features/wallet/domain/entities/wallet_entity.dart';


class WalletModel extends WalletEntity {
  WalletModel({required super.id, required super.name, super.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
    );
  }
}
