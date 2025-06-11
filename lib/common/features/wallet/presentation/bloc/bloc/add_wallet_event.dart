part of 'add_wallet_bloc.dart';

@immutable
abstract class AddWalletEvent {}

class SubmitWalletEvent extends AddWalletEvent {
  final String id;
  final String name;
  final String? imageUrl;
  final double amount;

  SubmitWalletEvent({
    required this.id,
    required this.name,
    this.imageUrl,
    this.amount = 0.0,
  });
}

class FetchWalletsEvent extends AddWalletEvent {}