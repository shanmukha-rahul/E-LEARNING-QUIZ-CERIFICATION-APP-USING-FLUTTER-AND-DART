import 'package:flutter/material.dart';
import '../services/quiz_service.dart';

import '../widgets/passed_quiz_card.dart';
import '../widgets/failed_quiz_card.dart';

class QuizHistoryScreen extends StatelessWidget {
  final String? courseId; // Optional: filter by course

  const QuizHistoryScreen({super.key, this.courseId});

  @override
  Widget build(BuildContext context) {
    final quizService = QuizService();
    final attempts = courseId != null
        ? quizService.getQuizAttempts('1', courseId!)
        : quizService.getUserQuizResults('1');

    return Scaffold(
      appBar: AppBar(
        title: courseId != null 
            ? const Text('Quiz History')
            : const Text('All Quiz Attempts'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: attempts.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: attempts.length,
              itemBuilder: (context, index) {
                final attempt = attempts[index];
                final course = quizService.getCourse(attempt.courseId);
                
                if (attempt.passed) {
                  return PassedQuizCard(
                    attempt: attempt,
                    course: course!,
                    onViewCertificate: () {
                      // Navigate to certificate
                    },
                  );
                } else {
                  return FailedQuizCard(
                    attempt: attempt,
                    course: course!,
                    onReattempt: quizService.canAttemptQuiz('1', attempt.quizId)
                        ? () {
                            // Navigate to quiz screen for reattempt
                          }
                        : null,
                  );
                }
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.quiz_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No Quiz Attempts Yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Take quizzes to see your history here',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}