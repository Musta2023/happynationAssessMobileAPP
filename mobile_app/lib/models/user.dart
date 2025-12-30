class User {
  final int id;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String email;
  final String role;
  final String? department;
  final DateTime? emailVerifiedAt;
  final DateTime? createdAt;  // Changed to nullable
  final DateTime? updatedAt;  // Changed to nullable

  User({
    required this.id,
    this.name,
    this.firstName,
    this.lastName,
    required this.email,
    required this.role,
    this.department,
    this.emailVerifiedAt,
    this.createdAt,           // Made optional
    this.updatedAt,           // Made optional
  });

  /// A computed property to get the user's full name.
  String get fullName {
    if (name != null && name!.isNotEmpty) {
      return name!;
    }
    
    final fName = firstName ?? '';
    final lName = lastName ?? '';
    final firstAndLastName = '$fName $lName'.trim();

    if (firstAndLastName.isNotEmpty) {
      return firstAndLastName;
    }
    
    if (email.isNotEmpty) {
      return email;
    }

    return 'Unknown User';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String,
      role: json['role'] as String,
      department: json['department'] as String?,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,  // Handle null case
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,  // Handle null case
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'role': role,
      'department': department,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),  // Handle nullable
      'updated_at': updatedAt?.toIso8601String(),  // Handle nullable
    };
  }
}
