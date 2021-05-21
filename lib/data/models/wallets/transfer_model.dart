import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Transaction extends Equatable {
  String id;
  String userId;
  String walletId;
  String otherUserId;
  String postId;
  String otherUsername;
  String origin;
  String action;
  double balance;
  String createdAt;
  String updatedAt;
  String photoUrl;
  dynamic dateTransaction;

  Transaction({
    this.id,
    this.userId,
    this.walletId,
    this.otherUserId,
    this.postId,
    this.otherUsername,
    this.origin,
    this.action,
    this.balance,
    this.createdAt,
    this.updatedAt,
    this.photoUrl,
    this.dateTransaction,
  }) {
    // this.dateTransaction =
    //     DateFormat('dd-MM-yyyy').format(DateTime.parse(createdAt));
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['userId'],
      walletId: json['walletId'],
      otherUserId: json['otherUserId'],
      postId: json['postId'],
      otherUsername: json['otherUsername'],
      origin: json['origin'],
      action: json['action'],
      balance: (json['balance'] is double
          ? json['balance']
          : double.parse(json['balance'])),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      photoUrl: json['photoUrl'],
      dateTransaction: json['dateTransaction'],
    );
  }

  @override
  List<Object> get props => [
        id,
        userId,
        walletId,
        otherUserId,
        postId,
        otherUsername,
        origin,
        action,
        balance,
        createdAt,
        updatedAt,
        photoUrl,
        dateTransaction,
      ];
}
