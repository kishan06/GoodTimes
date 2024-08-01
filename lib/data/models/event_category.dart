class EventCategoryModal {
  final int id;
  final String title;
  final String description;
  final String image;
   String? icon_svg;

  EventCategoryModal({
    required this.title,
    required this.image,
    required this.description,
    required this.id,
    this.icon_svg
  });

  factory EventCategoryModal.fromjson(Map<String, dynamic> json) {
    return EventCategoryModal(
      title: json["title"],
      image: json["image"],
      description: json["description"],
      id: json["id"],
      icon_svg: json['icon_svg']??""
    );
  }
}
