import 'package:flutter/material.dart';
import '../services/quiz_service.dart';
import '../models/quiz_attempts.dart';
import '../models/course.dart';

class ProgressTrackerScreen extends StatelessWidget {
  const ProgressTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizService = QuizService();
    final courses = quizService.getCourses();
    final enrolledCourses = courses.where((course) => course.isEnrolled).toList();
    final quizAttempts = quizService.getUserQuizResults('1'); // Now returns List<QuizAttempt>

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: enrolledCourses.isEmpty
          ? _buildEmptyState(context)
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildProgressOverview(quizAttempts, enrolledCourses),
                const SizedBox(height: 24),
                _buildEnrolledCourses(enrolledCourses, quizService, context),
                const SizedBox(height: 24),
                _buildQuizHistory(quizAttempts, quizService, context),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No Progress Yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enroll in courses to track your progress',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Browse Courses'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressOverview(List<QuizAttempt> quizAttempts, List<Course> enrolledCourses) {
    final completedQuizzes = quizAttempts.where((attempt) => attempt.passed).length;
    final totalScore = quizAttempts.isEmpty ? 0 : 
        quizAttempts.map((r) => r.score).reduce((a, b) => a + b) ~/ quizAttempts.length;
    
    // Calculate real progress based on quiz completion
    final totalProgress = enrolledCourses.isEmpty ? 0 : 
        (completedQuizzes / enrolledCourses.length * 100).toInt();

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Learning Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Courses', '${enrolledCourses.length}', Icons.school, Colors.blue),
                _buildStatItem('Completed', '$completedQuizzes', Icons.check_circle, Colors.green),
                _buildStatItem('Progress', '$totalProgress%', Icons.trending_up, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildEnrolledCourses(List<Course> enrolledCourses, QuizService quizService, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Courses',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...enrolledCourses.map((course) {
          final quiz = quizService.getQuizByCourse(course.id);
          final quizAttempts = quizService.getQuizAttempts('1', course.id);
          final courseQuizAttempt = quizAttempts.where((attempt) => attempt.quizId == course.id).toList();
          
          // Calculate real progress for each course
          double progress = 0.0;
          String progressText = 'Not Started';
          
          if (courseQuizAttempt.isNotEmpty) {
            final attempt = courseQuizAttempt.first;
            progress = attempt.score / 100;
            progressText = attempt.passed ? 'Completed' : 'In Progress (${attempt.score}%)';
          } else if (quiz != null) {
            progress = 0.3; // Default progress if enrolled but not attempted
            progressText = 'In Progress (30%)';
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(course.imageUrl),
                radius: 25,
              ),
              title: Text(
                course.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress == 1.0 ? Colors.green : Colors.blue
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    progressText,
                    style: TextStyle(
                      fontSize: 12,
                      color: progress == 1.0 ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
              trailing: courseQuizAttempt.isNotEmpty && courseQuizAttempt.first.passed
                  ? Icon(Icons.verified, color: Colors.green)
                  : const Icon(Icons.play_arrow, color: Colors.blue),
              onTap: () {
                // Navigate to course detail
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildQuizHistory(List<QuizAttempt> quizAttempts, QuizService quizService, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quiz History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        quizAttempts.isEmpty
            ? Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.quiz, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('No quiz attempts yet'),
                  ],
                ),
              )
            : Column(
                children: quizAttempts.map((attempt) {
                  final courses = quizService.getCourses();
                  final course = courses.firstWhere(
                    (course) => course.id == attempt.courseId,
                    orElse: () => Course(
                      id: attempt.courseId,
                      title: 'Course ${attempt.courseId}',
                      description: '',
                      instructor: '',
                      rating: 0.0,
                      students: 0,
                      imageUrl: '',
                      videoUrl: '',
                      duration: 0,
                      categories: [],
                    ),
                  );

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: attempt.passed ? Colors.green[50] : Colors.red[50],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          attempt.passed ? Icons.check : Icons.close,
                          color: attempt.passed ? Colors.green : Colors.red,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        course.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Score: ${attempt.score}%'),
                          Text(
                            '${attempt.correctAnswers}/${attempt.totalQuestions} correct',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            'Time: ${attempt.timeTaken ~/ 60}m ${attempt.timeTaken % 60}s',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            'Attempt: ${attempt.attemptNumber}/2',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Chip(
                        label: Text(
                          attempt.passed ? 'Passed' : 'Failed',
                          style: TextStyle(
                            color: attempt.passed ? Colors.green : Colors.red,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: attempt.passed ? Colors.green[50] : Colors.red[50],
                      ),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }
}