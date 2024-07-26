class FaqModel {
  final String question;
  final String answer;

  FaqModel({
    required this.question,
    required this.answer,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      question: json['question'],
      answer: json['answer'],
    );
  }
}