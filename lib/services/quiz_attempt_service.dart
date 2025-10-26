import '../models/quiz_attempts.dart';

class QuizAttemptService {
  final List<QuizAttempt> _quizAttempts = [];

  // Get all attempts for a user
  List<QuizAttempt> getUserAttempts(String userId) {
    return _quizAttempts.where((attempt) => attempt.userId == userId).toList();
  }

  // Get attempts for specific quiz
  List<QuizAttempt> getQuizAttempts(String userId, String quizId) {
    return _quizAttempts
        .where((attempt) => attempt.userId == userId && attempt.quizId == quizId)
        .toList();
  }

  // Get latest attempt for a quiz
  QuizAttempt? getLatestAttempt(String userId, String quizId) {
    final attempts = getQuizAttempts(userId, quizId);
    if (attempts.isEmpty) return null;
    
    attempts.sort((a, b) => b.attemptedAt.compareTo(a.attemptedAt));
    return attempts.first;
  }

  // Get remaining attempts
  int getRemainingAttempts(String userId, String quizId) {
    final attempts = getQuizAttempts(userId, quizId);
    final usedAttempts = attempts.length;
    return 2 - usedAttempts; // Max 2 attempts
  }

  // Check if user can reattempt
  bool canReattempt(String userId, String quizId) {
    return getRemainingAttempts(userId, quizId) > 0;
  }

  // Check if quiz is passed
  bool isQuizPassed(String userId, String quizId) {
    final attempts = getQuizAttempts(userId, quizId);
    return attempts.any((attempt) => attempt.passed);
  }

  // Add new attempt
  QuizAttempt addAttempt({
    required String userId,
    required String quizId,
    required String courseId,
    required int score,
    required int totalQuestions,
    required int correctAnswers,
    required int timeTaken,
    required bool passed,
  }) {
    final attempts = getQuizAttempts(userId, quizId);
    final attemptNumber = attempts.length + 1;

    final attempt = QuizAttempt(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      quizId: quizId,
      courseId: courseId,
      score: score,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      timeTaken: timeTaken,
      attemptedAt: DateTime.now(),
      passed: passed,
      attemptNumber: attemptNumber,
      certificateGenerated: passed && correctAnswers >= 8,
    );

    _quizAttempts.add(attempt);
    return attempt;
  }

  // Mark certificate as generated
  void markCertificateGenerated(String attemptId) {
    final index = _quizAttempts.indexWhere((attempt) => attempt.id == attemptId);
    if (index != -1) {
      _quizAttempts[index] = QuizAttempt(
        id: _quizAttempts[index].id,
        userId: _quizAttempts[index].userId,
        quizId: _quizAttempts[index].quizId,
        courseId: _quizAttempts[index].courseId,
        score: _quizAttempts[index].score,
        totalQuestions: _quizAttempts[index].totalQuestions,
        correctAnswers: _quizAttempts[index].correctAnswers,
        timeTaken: _quizAttempts[index].timeTaken,
        attemptedAt: _quizAttempts[index].attemptedAt,
        passed: _quizAttempts[index].passed,
        attemptNumber: _quizAttempts[index].attemptNumber,
        certificateGenerated: true,
      );
    }
  }

  // Get all attempts sorted by date (newest first)
  List<QuizAttempt> getAllAttemptsSorted(String userId) {
    final attempts = getUserAttempts(userId);
    attempts.sort((a, b) => b.attemptedAt.compareTo(a.attemptedAt));
    return attempts;
  }

  // Check if certificate can be generated (passed with 8+ correct answers)
  bool canGenerateCertificate(QuizAttempt attempt) {
    return attempt.passed && attempt.correctAnswers >= 8 && !attempt.certificateGenerated;
  }
}