import 'package:flutter/material.dart';
import '../models/quiz_attempts.dart';
import '../services/quiz_service.dart';
import '../services/certificate_service.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizAttempt attempt;
  final String courseId;

  const QuizResultScreen({
    super.key,
    required this.attempt,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    final quizService = QuizService();
    final certificateService = CertificateService();
    final course = quizService.getCourse(courseId);
    final canReattempt = quizService.canAttemptQuiz('1', attempt.quizId);

    // Generate certificate if passed with 8+ correct answers
    if (attempt.passed && attempt.correctAnswers >= 8) {
      final certificate = certificateService.generateCertificate(
        '1',
        attempt.quizId,
        course?.title ?? 'Course',
      );
      if (certificate != null) {
        print('Certificate generated: ${certificate.courseName}');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: attempt.passed ? Colors.green : Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Result Icon
            Icon(
              attempt.passed ? Icons.check_circle : Icons.cancel,
              size: 80,
              color: attempt.passed ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 16),
            
            // Result Title
            Text(
              attempt.passed ? 'Congratulations!' : 'Quiz Failed',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Score
            Text(
              'Score: ${attempt.score}%',
              style: TextStyle(
                fontSize: 20,
                color: attempt.passed ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow('Correct Answers', '${attempt.correctAnswers}/${attempt.totalQuestions}'),
                    _buildDetailRow('Time Taken', '${attempt.timeTaken ~/ 60}m ${attempt.timeTaken % 60}s'),
                    _buildDetailRow('Attempt Number', '${attempt.attemptNumber}/2'),
                    if (attempt.passed && attempt.correctAnswers >= 8)
                      _buildDetailRow('Certificate', 'Generated ✓', isSuccess: true),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Buttons
            if (attempt.passed) ...[
              if (attempt.correctAnswers >= 8)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to certificates screen
                      Navigator.pushNamed(context, '/certificates');
                    },
                    icon: const Icon(Icons.card_membership),
                    label: const Text('View Certificate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('Back to Courses'),
                ),
              ),
            ] else ...[
              if (canReattempt)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to quiz screen for reattempt
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Reattempt Quiz'),
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('Back to Courses'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isSuccess = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              color: isSuccess ? Colors.green : Colors.black,
              fontWeight: isSuccess ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}