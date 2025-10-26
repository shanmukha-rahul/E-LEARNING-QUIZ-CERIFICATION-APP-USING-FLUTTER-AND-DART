import 'package:flutter/material.dart';
import '../models/quiz_attempts.dart';
import '../models/course.dart';

class FailedQuizCard extends StatelessWidget {
  final QuizAttempt attempt;
  final Course course;
  final VoidCallback? onReattempt;

  const FailedQuizCard({
    super.key,
    required this.attempt,
    required this.course,
    this.onReattempt,
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
                    color: Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.cancel, color: Colors.red, size: 24),
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
                        'Attempt ${attempt.attemptNumber} - Failed',
                        style: const TextStyle(color: Colors.red),
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
                _buildDetailItem('Correct', '${attempt.correctAnswers}/${attempt.totalQuestions}', Icons.close),
                const SizedBox(width: 16),
                _buildDetailItem('Time', '${attempt.timeTaken ~/ 60}m', Icons.timer),
              ],
            ),

            const SizedBox(height: 12),

            // Reattempt Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: onReattempt != null ? Colors.orange[50] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    onReattempt != null ? Icons.refresh : Icons.block,
                    color: onReattempt != null ? Colors.orange : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      onReattempt != null 
                          ? 'You can reattempt this quiz'
                          : 'No attempts remaining',
                      style: TextStyle(
                        color: onReattempt != null ? Colors.orange : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (onReattempt != null) ...[
                    ElevatedButton(
                      onPressed: onReattempt,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text('Reattempt'),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Date
            Text(
              'Attempted: ${_formatDate(attempt.attemptedAt)}',
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