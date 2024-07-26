class WalletModel {
  final String balance;
  final String deposit;
  final String earnings;
  final int coins;
  final String withdrawalBalance;

  WalletModel(
      {required this.balance,
      required this.deposit,
      required this.earnings,
      required this.coins,
      required this.withdrawalBalance});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: json["balance"],
      deposit: json["deposit"],
      earnings: json["earnings"],
      coins: json["coins"],
      withdrawalBalance: json["withdrawal_balance"],
    );
  }
}

// transactionsModel

class WalletTransactionsModel {
  final String transactionType;
  final String transactionStatus;
  final String amount;
  final String comment;
  final int coins;
  final String transactionTypeDisplay;

  WalletTransactionsModel({
    required this.transactionType,
    required this.transactionStatus,
    required this.amount,
    required this.comment,
    required this.coins,
    required this.transactionTypeDisplay,
  });
  factory WalletTransactionsModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionsModel(
      transactionType: json["transaction_type"],
      transactionStatus: json["transaction_status"],
      amount: json["amount"],
      transactionTypeDisplay: json["transaction_type_display"],
      comment: json["comment"],
      coins: json["coins"],
    );
  }

}

  