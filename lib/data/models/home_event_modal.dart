class HomeEventsModel {
  final int? id;
  final String? title;
  final String? description;
  final String? thumbnail;
  final String? startDate;
  final String? endDate;
  final String? entryFee;

  HomeEventsModel({
    this.id,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.thumbnail,
    this.entryFee,
  });

  factory HomeEventsModel.fromJson(Map<String, dynamic> json) {
    return HomeEventsModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        thumbnail: json["image"],
        entryFee: json["entry_fee"],
        startDate: json["start_date"],
        endDate: json["end_date"]
      );
  }
}