class AccountTransferModal {
  final bool isTransferred;
  final bool pwdChangedPostTransfer;
  final bool isOnBoarded;

  AccountTransferModal({
    required this.isTransferred,
    required this.pwdChangedPostTransfer,
    required this.isOnBoarded,
  });

  factory AccountTransferModal.fromjson(Map<String, dynamic> json) {
    return AccountTransferModal(
        isTransferred: json["is_transferred"],
        pwdChangedPostTransfer: json["pwd_changed_post_transfer"],
        isOnBoarded: json["is_onboarded"],
        );
  }
}
