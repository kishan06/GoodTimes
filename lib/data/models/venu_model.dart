class VenuModel {
  final int? id;
  final String? title;
  final String? description;
  final String? address;
  final String? image;

  VenuModel(
      {required this.id,
      required this.title,
      required this.address,
      this.description,
      this.image});

  factory VenuModel.fromJson(Map<String, dynamic> json) {
    return VenuModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      address: json['address'],
      image: json["image"],
    );
  }
}
