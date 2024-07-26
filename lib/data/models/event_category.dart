class EventCategoryModal {
  final int id;
  final String title;
  final String description;
  final String image;

  EventCategoryModal({
    required this.title,
    required this.image,
    required this.description,
    required this.id,
  });

  factory EventCategoryModal.fromjson(Map<String, dynamic> json) {
    return EventCategoryModal(
      title: json["title"],
      image: json["image"],
      description: json["description"],
      id: json["id"],
    );
  }
}
