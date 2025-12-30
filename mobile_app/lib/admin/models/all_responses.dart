class AllResponses {
  final int id;
  final int userId;
  final int globalScore;
  final String risk;
  final DateTime createdAt;
  final User user;

  AllResponses({
    required this.id,
    required this.userId,
    required this.globalScore,
    required this.risk,
    required this.createdAt,
    required this.user,
  });

  factory AllResponses.fromJson(Map<String, dynamic> json) {
    return AllResponses(
      id: json['id'],
      userId: json['user_id'],
      globalScore: json['global_score'],
      risk: json['risk'],
      createdAt: DateTime.parse(json['created_at']),
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
