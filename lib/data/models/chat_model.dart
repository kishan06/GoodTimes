class ChatModel {
  final int? groupId;
  final String? message;
  final dynamic timestamp;
  final UserModel? user;

  ChatModel({
     this.groupId,
    this.message,
     this.timestamp,
      this.user,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      groupId: json["group"],
      message: json["message"],
      timestamp: json["timestamp"],
      user: UserModel.fromJson(json['user']),
    );
  }
}

class UserModel {
  final String? email;
  final String? profilePhoto;
  final String? firstName;

  UserModel(
      {this.email,
      this.profilePhoto,
      this.firstName});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json["email"],
      profilePhoto: json["profile_photo"],
      firstName: json["first_name"],
    );
  }
}
