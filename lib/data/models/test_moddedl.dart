class TestModel{
  final int userId;
  final int id;
  final String title;
  final bool completed;
   TestModel({required this.userId, required this.id, required this.title, required this.completed});

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}