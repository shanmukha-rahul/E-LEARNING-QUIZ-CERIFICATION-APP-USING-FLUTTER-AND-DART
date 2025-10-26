import 'package:flutter/material.dart';
import '../models/quiz_attempts.dart';
import '../models/course.dart';

class PassedQuizCard extends StatelessWidget {
  final QuizAttempt attempt;
  final Course course;
  final VoidCallback onViewCertificate;

  const PassedQuizCard({
    super.key,
    required this.attempt,
    required this.course,
    required this.onViewCertificate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: Colors.green, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Attempt ${attempt.attemptNumber} - Passed',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Score and Details
            Row(
              children: [
                _buildDetailItem('Score', '${attempt.score}%', Icons.assessment),
                const SizedBox(width: 16),
                _buildDetailItem('Correct', '${attempt.correctAnswers}/${attempt.totalQuestions}', Icons.check),
                const SizedBox(width: 16),
                _buildDetailItem('Time', '${attempt.timeTaken ~/ 60}m', Icons.timer),
              ],
            ),

            const SizedBox(height: 12),

            // Certificate Section
            if (attempt.certificateGenerated) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.card_membership, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Certificate Generated',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: onViewCertificate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text('View Certificate'),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 8),

            // Date
            Text(
              'Completed: ${_formatDate(attempt.attemptedAt)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}