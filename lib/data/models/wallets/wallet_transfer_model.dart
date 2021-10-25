import 'package:equatable/equatable.dart';

class WalletTransfer extends Equatable {
  String id;
  String userId;
  String walletId;
  String? icon;
  String? otherUserId;
  String? postId;
  String? otherUsername;
  String? learningTrackId;
  String origin;
  String action;
  double balance;
  String createdAt;
  String updatedAt;
  String? photoUrl;
  bool fromPlatform = false;
  dynamic dateTransaction;
  String? description;

  WalletTransfer(
      {required this.id,
      required this.userId,
      required this.walletId,
      this.icon,
      this.otherUserId,
      this.postId,
      this.otherUsername,
      this.learningTrackId,
      required this.origin,
      required this.action,
      required this.balance,
      required this.createdAt,
      required this.updatedAt,
      this.photoUrl,
      this.dateTransaction,
      required this.fromPlatform,
      this.description}) {
    // this.dateTransaction =
    //     DateFormat('dd-MM-yyyy').format(DateTime.parse(createdAt));
  }

  factory WalletTransfer.fromJson(Map<String, dynamic> json) {
    return WalletTransfer(
        id: json['id'],
        userId: json['userId'],
        walletId: json['walletId'],
        icon: json['icon'],
        otherUserId: json['otherUserId'],
        postId: json['postId'],
        otherUsername: json['otherUsername'],
        learningTrackId: json['learningTrackId'],
        origin: json['origin'],
        action: json['action'],
        balance: (json['balance'] is double
            ? json['balance']
            : double.parse(json['balance'])),
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        photoUrl: json['photoUrl'],
        dateTransaction: json['dateTransaction'],
        fromPlatform:
            (json['fromPlatform'] == null ? false : json['fromPlatform']),
        description: json['description']);
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        walletId,
        icon,
        otherUserId,
        postId,
        otherUsername,
        learningTrackId,
        origin,
        action,
        balance,
        createdAt,
        updatedAt,
        photoUrl,
        dateTransaction,
        fromPlatform,
        description
      ];
}
