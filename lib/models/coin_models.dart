import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Coin extends Equatable {
  final String? name;
  final String? fullName;
  final double price;

  const Coin({required this.name, required this.fullName, required this.price});

  @override
  List<Object?> get props => [name, fullName, price];

  @override
  String toString() =>
      'Coin { name: $name, fullName: $fullName, price: $price}';

  factory Coin.fromMap(Map<String, dynamic> ajson) {
    return Coin(
        name: ajson['CoinInfo']['Name'],
        fullName: ajson['CoinInfo']['FullName'],
        price: (ajson['RAW']['USD']['PRICE'] as num).toDouble());
  }
}
