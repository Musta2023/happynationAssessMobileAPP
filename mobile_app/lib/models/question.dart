class Question {
  final int id;
  final String questionText;
  final String category;
  final String type;
  final bool isActive;

  Question({
    required this.id,
    required this.questionText,
    required this.category,
    required this.type,
    required this.isActive,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionText: json['question_text'],
      category: json['category'],
      type: json['type'],
      isActive: json['is_active'] == 1,
    );
  }
}
