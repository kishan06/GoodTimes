class WithdrawalTransactionsModel {
  final int coins;
  final String amount;
  final String? notes;
  final String? reply;
  final String? status;
  final DateTime createdOn;

  WithdrawalTransactionsModel({
    required this.coins,
    required this.amount,
    this.notes,
    this.reply,
    this.status,
    required this.createdOn,
  });
  factory WithdrawalTransactionsModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalTransactionsModel(
      coins: json["coins"],
      amount: json["amount"],
      notes: json["notes"],
      reply: json["reply"],
      status: json["status"],
      createdOn: DateTime.parse(json['created_on']),

    );
  }
}


class ReffralRecordsModel {
  final int coins;
  final String value;
  final bool sell;
  final String uniqueToken;

  ReffralRecordsModel({
    required this.coins,
    required this.value,
    required this.sell,
    required this.uniqueToken,
  });
  factory ReffralRecordsModel.fromJson(Map<String, dynamic> json) {
    return ReffralRecordsModel(
      coins: json["coins"],
      sell: json["sell"],
      value: json["value"],
      uniqueToken: json["unique_token"]

    );
  }
}
