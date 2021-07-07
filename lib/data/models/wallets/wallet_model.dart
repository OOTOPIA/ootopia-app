import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  String id;
  String userId;
  double totalBalance;
  String createdAt;
  String updatedAt;

  Wallet({
    required this.id,
    required this.userId,
    required this.totalBalance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> parsedJson) {
    return Wallet(
      id: parsedJson['id'],
      userId: parsedJson['userId'],
      totalBalance: double.parse(parsedJson['totalBalance']),
      createdAt: parsedJson['createdAt'],
      updatedAt: parsedJson['updatedAt'],
    );
  }

  @override
  List<Object> get props => [
        id,
        userId,
        totalBalance,
        createdAt,
        updatedAt,
      ];
}
