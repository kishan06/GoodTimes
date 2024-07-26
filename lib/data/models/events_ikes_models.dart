class EventsLikeModel {
  final int id;
  final String thumbnail;
  final String title;
  final DateTime startDate;
  final DateTime endDate;

  EventsLikeModel({
    required this.id,
    required this.thumbnail,
    required this.title,
    required this.startDate,
    required this.endDate
  });

  factory EventsLikeModel.fromJson(Map<String, dynamic> json) {
    return EventsLikeModel(
      id: json["id"],
      thumbnail: json['image'],
      title: json['title'],
      startDate: DateTime.parse(json["start_date"]),
      endDate: DateTime.parse(json["end_date"])
    );
  }
}
