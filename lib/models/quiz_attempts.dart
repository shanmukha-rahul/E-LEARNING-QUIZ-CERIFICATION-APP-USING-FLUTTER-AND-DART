class QuizAttempt {
  final String id;
  final String userId;
  final String quizId;
  final String courseId;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int timeTaken;
  final DateTime attemptedAt;
  final bool passed;
  final int attemptNumber;
  final bool certificateGenerated;

  QuizAttempt({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.courseId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeTaken,
    required this.attemptedAt,
    required this.passed,
    required this.attemptNumber,
    this.certificateGenerated = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'quizId': quizId,
      'courseId': courseId,
      'score': score,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'timeTaken': timeTaken,
      'attemptedAt': attemptedAt.toIso8601String(),
      'passed': passed,
      'attemptNumber': attemptNumber,
      'certificateGenerated': certificateGenerated,
    };
  }

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      id: json['id'],
      userId: json['userId'],
      quizId: json['quizId'],
      courseId: json['courseId'],
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      timeTaken: json['timeTaken'],
      attemptedAt: DateTime.parse(json['attemptedAt']),
      passed: json['passed'],
      attemptNumber: json['attemptNumber'],
      certificateGenerated: json['certificateGenerated'] ?? false,
    );
  }
}