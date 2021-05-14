import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  String id;
  String userId;
  String walletId;
  String otherUserId;
  String otherUsername;
  String origin;
  String action;
  int balance;
  DateTime createdAt;
  DateTime updatedAt;

  Transaction({
    this.id,
    this.userId,
    this.walletId,
    this.otherUserId,
    this.otherUsername,
    this.origin,
    this.action,
    this.balance,
    this.createdAt,
    this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['userId'],
      walletId: json['walletId'],
      otherUserId: json['otherUserId'],
      otherUsername: json['otherUsername'],
      origin: json['origin'],
      action: json['action'],
      balance: json['balance'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  @override
  List<Object> get props => [
        id,
        userId,
        walletId,
        otherUserId,
        otherUsername,
        origin,
        action,
        balance,
        createdAt,
        updatedAt,
      ];
}
