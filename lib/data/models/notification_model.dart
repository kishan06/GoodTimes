class NotificationList {
  final int id;
  final String message;
  final String title;
  final String date;

  NotificationList({
    required this.id,
    required this.message,
    required this.title,
    required this.date,
  });

  factory NotificationList.fromJson(Map<String, dynamic> json) {
    return NotificationList(
      id: json["id"],
      message: json["title"],
      title: json["message"],
      date: json["created_on"],
    );
  }
}


class NotificationCategory {
  final int id;
  final String categoryName;
  final String categoryTitle;
  final bool isEnabled;

  NotificationCategory({
    required this.id,
    required this.categoryName,
    required this.categoryTitle,
    required this.isEnabled,
  });

  factory NotificationCategory.fromJson(Map<String, dynamic> json) {
    return NotificationCategory(
      id: json["id"],
      categoryName: json["notification_category"],
      categoryTitle: json["notification_category_display"],
      isEnabled: json["is_enabled"],
    );
  }
}
