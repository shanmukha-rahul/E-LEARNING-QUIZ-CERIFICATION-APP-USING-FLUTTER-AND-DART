class Quiz {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final int timeLimit;
  final int passingScore;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.timeLimit,
    required this.passingScore,
    required this.questions,
  });
}

class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final int points;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.points = 1,
  });
}

class QuizResult {
  final String quizId;
  final String userId;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int timeTaken;
  final DateTime completedAt;
  final bool passed;

  QuizResult({
    required this.quizId,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeTaken,
    required this.completedAt,
    required this.passed,
  });
}