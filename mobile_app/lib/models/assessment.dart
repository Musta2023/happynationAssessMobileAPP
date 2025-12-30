class Assessment {
  final String id;
  final String title;
  final String? description;
  final List<String> questionIds; // List of question IDs belonging to this assessment
  final bool? isAnswered;

  Assessment({
    required this.id,
    required this.title,
    this.description,
    this.questionIds = const [],
    this.isAnswered,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id']?.toString() ?? 'N/A',
      title: json['title']?.toString() ?? 'Untitled Assessment',
      description: json['description']?.toString(),
      questionIds: (json['question_ids'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isAnswered: json['is_answered'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'question_ids': questionIds,
      'is_answered': isAnswered,
    };
  }
}
