import 'package:crypto_app/models/coin_models.dart';
import 'package:crypto_app/models/failure_model.dart';
// part of 'crypto_bloc.dart';

import 'package:equatable/equatable.dart';

enum CryptoStatus { initial, loading, loaded, error }

class CryptoState extends Equatable {
  final List<Coin> coins;
  final CryptoStatus status;
  final Failure failure;

  CryptoState(
      {required this.coins, required this.status, required this.failure});

  factory CryptoState.initial() =>
      CryptoState(coins: [], status: CryptoStatus.initial, failure: Failure());

  @override
  List<Object?> get props => [coins, status, failure];

  CryptoState copyWith({
    List<Coin>? coins,
    CryptoStatus? status,
    Failure? failure,
  }) {
    return CryptoState(
        coins: coins ?? this.coins,
        status: status ?? this.status,
        failure: failure ?? this.failure);
  }
}
