import 'package:intl/intl.dart';

enum TransactionType { reload, supportSent, supportReceived, planPurchase, unknown }

class TransactionItem {
  final String id;
  final String title;
  final double amount;
  final String status;
  final DateTime createdAt;
  final TransactionType type;
  final bool isCredit;

  TransactionItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.type,
    required this.isCredit,
  });

  factory TransactionItem.fromCoinTransaction(Map<String, dynamic> json) {
    String typeStr = json['type'] ?? '';
    TransactionType tType = TransactionType.unknown;
    String titleStr = "Transaction";
    bool credit = true;

    if (typeStr == 'RELOAD') {
      tType = TransactionType.reload;
      titleStr = json['packageId']?['name'] ?? "Coin Reload";
      credit = true;
    } else if (typeStr == 'SUPPORT_SENT') {
      tType = TransactionType.supportSent;
      titleStr = "Sent Support to ${json['recipient']?['name'] ?? 'User'}";
      credit = false;
    } else if (typeStr == 'SUPPORT_RECEIVED') {
      tType = TransactionType.supportReceived;
      titleStr = "Received Support from ${json['sender']?['name'] ?? 'User'}";
      credit = true;
    }

    return TransactionItem(
      id: json['_id'] ?? '',
      title: titleStr,
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      type: tType,
      isCredit: credit,
    );
  }

  factory TransactionItem.fromPlanTransaction(Map<String, dynamic> json) {
    return TransactionItem(
      id: json['_id'] ?? '',
      title: json['plan']?['name'] ?? "Subscription Plan",
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      type: TransactionType.planPurchase,
      isCredit: false, // You pay for a plan, so it's a debit from your pocket
    );
  }

  String get formattedDate {
    return DateFormat('MMM dd, yyyy h:mm a').format(createdAt);
  }
}
