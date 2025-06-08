part of 'add_wallet_bloc.dart';

@immutable
abstract class AddWalletEvent {}

class SubmitWalletEvent extends AddWalletEvent {
  final String id;
  final String name;
  final String? imageUrl;

  SubmitWalletEvent({
    required this.id,
    required this.name,
    this.imageUrl,
  });
}

class FetchWalletsEvent extends AddWalletEvent {}