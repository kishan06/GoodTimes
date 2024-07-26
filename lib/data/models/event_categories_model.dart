class EventCategoriesModdel {
  final int id;
  final String title;
  final String icon;
  bool selected;

  EventCategoriesModdel({
    required this.id,
    required this.title,
    required this.icon,
    required this.selected
  });

  factory EventCategoriesModdel.fromJson(Map<String, dynamic> json) {
    return EventCategoriesModdel(
      id: json["id"],
      title: json["title"],
      icon: json["image"],
      selected: false
    );
  }
}
