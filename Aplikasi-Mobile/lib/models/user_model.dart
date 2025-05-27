class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String? phone;
  final String? bio;
  final DateTime joinDate;
  final DateTime? birthDate;
  final String? gender;
  final String? location;
  final int totalQuizzes;
  final int totalScore;
  final int points;
  final int level;
  final int? grade;
  final String? school;
  final String? major;
  final List<String> achievements;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.phone,
    this.bio,
    DateTime? joinDate,
    this.birthDate,
    this.gender,
    this.location,
    this.totalQuizzes = 0,
    this.totalScore = 0,
    this.points = 0,
    this.level = 1,
    this.grade,
    this.school,
    this.major,
    this.achievements = const [],
  }) : joinDate = joinDate ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? json['profile_image_url'],
      phone: json['phone'],
      bio: json['bio'],
      joinDate: DateTime.tryParse(json['joinDate'] ?? json['join_date'] ?? '') ?? DateTime.now(),
      birthDate: json['birthDate'] != null ? DateTime.tryParse(json['birthDate']) : null,
      gender: json['gender'],
      location: json['location'],
      totalQuizzes: json['totalQuizzes'] ?? json['total_quizzes'] ?? 0,
      totalScore: json['totalScore'] ?? json['total_score'] ?? 0,
      points: json['points'] ?? 0,
      level: json['level'] is String
          ? int.tryParse(json['level']) ?? 1
          : json['level'] ?? 1,
      grade: json['grade'],
      school: json['school'],
      major: json['major'],
      achievements: List<String>.from(json['achievements'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'phone': phone,
      'bio': bio,
      'joinDate': joinDate.toIso8601String(),
      'birthDate': birthDate?.toIso8601String(),
      'gender': gender,
      'location': location,
      'totalQuizzes': totalQuizzes,
      'totalScore': totalScore,
      'points': points,
      'level': level,
      'grade': grade,
      'school': school,
      'major': major,
      'achievements': achievements,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    String? phone,
    String? bio,
    DateTime? joinDate,
    DateTime? birthDate,
    String? gender,
    String? location,
    int? totalQuizzes,
    int? totalScore,
    int? points,
    int? level,
    int? grade,
    String? school,
    String? major,
    List<String>? achievements,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      joinDate: joinDate ?? this.joinDate,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      totalQuizzes: totalQuizzes ?? this.totalQuizzes,
      totalScore: totalScore ?? this.totalScore,
      points: points ?? this.points,
      level: level ?? this.level,
      grade: grade ?? this.grade,
      school: school ?? this.school,
      major: major ?? this.major,
      achievements: achievements ?? this.achievements,
    );
  }

  String getInitials() {
    List<String> names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return 'U';
  }

  String getFirstName() {
    return name.split(' ')[0];
  }

  String getGradeInfo() {
    if (grade == null) return 'Kelas';
    String gradeText = 'Kelas $grade';
    if (major != null) {
      gradeText += ' $major';
    }
    return gradeText;
  }

  String getRank() {
    if (points >= 1000) return 'Master';
    if (points >= 750) return 'Expert';
    if (points >= 500) return 'Advanced';
    if (points >= 250) return 'Intermediate';
    return 'Beginner';
  }

  double get averageScore {
    if (totalQuizzes == 0) return 0.0;
    return totalScore / totalQuizzes;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, level: $level, totalQuizzes: $totalQuizzes, points: $points, totalScore: $totalScore)';
  }
}
