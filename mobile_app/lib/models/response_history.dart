import 'package:mobile_app/models/user.dart';

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
      id: json['id'] ?? 0,
      questionText: json['question_text'] ?? '',
      category: json['category'] ?? '',
      type: json['type'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }
}

class ResponseHistory {
  final int id;
  final User? user; // User can be null
  final int globalScore;
  final String? risk;
  final DateTime submittedAt;

  ResponseHistory({
    required this.id,
    this.user,
    required this.globalScore,
    this.risk,
    required this.submittedAt,
  });

  factory ResponseHistory.fromJson(Map<String, dynamic> json) {
    return ResponseHistory(
      id: json['id'] ?? 0,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      globalScore: json['global_score'] ?? 0,
      risk: json['risk'],
      submittedAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}

class ResponseDetail extends ResponseHistory {
  final List<ResponseItem> answers;
  final String? summary;
  final List<String>? recommendations;
  final int stressScore;
  final int motivationScore;
  final int satisfactionScore;

  ResponseDetail({
    required super.id,
    super.user,
    required super.globalScore,
    super.risk,
    required super.submittedAt,
    required this.answers,
    this.summary,
    this.recommendations,
    required this.stressScore,
    required this.motivationScore,
    required this.satisfactionScore,
  });

  factory ResponseDetail.fromJson(Map<String, dynamic> json) {
    return ResponseDetail(
      id: json['id'] ?? 0,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      globalScore: json['global_score'] ?? 0,
      risk: json['risk'],
      submittedAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      answers: (json['response_items'] as List?)
              ?.map((item) => ResponseItem.fromJson(item))
              .toList() ??
          [],
      summary: json['summary'],
      recommendations: (json['recommendations'] as List?)
          ?.map((item) => item.toString())
          .toList(),
      stressScore: json['stress_score'] ?? 0,
      motivationScore: json['motivation_score'] ?? 0,
      satisfactionScore: json['satisfaction_score'] ?? 0,
    );
  }
}

class ResponseItem {
  final int id;
  final int responseId;
  final int questionId;
  final String answerValue;
  final Question question;

  ResponseItem({
    required this.id,
    required this.responseId,
    required this.questionId,
    required this.answerValue,
    required this.question,
  });

  factory ResponseItem.fromJson(Map<String, dynamic> json) {
    return ResponseItem(
      id: json['id'] ?? 0,
      responseId: json['response_id'] ?? 0,
      questionId: json['question_id'] ?? 0,
      answerValue: json['answer_value'] ?? '',
      question: json['question'] != null
          ? Question.fromJson(json['question'])
          : Question(id: 0, questionText: '', category: '', type: '', isActive: true),
    );
  }
}
