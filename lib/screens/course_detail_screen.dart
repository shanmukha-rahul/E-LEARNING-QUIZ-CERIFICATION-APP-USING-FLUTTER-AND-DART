import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../services/quiz_service.dart';
import 'video_player_screen.dart';
import 'quiz_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Course _course;
  bool _isEnrolling = false;

  @override
  void initState() {
    super.initState();
    _course = widget.course;
  }

  Future<void> _enrollInCourse(BuildContext context) async {
    if (_isEnrolling || _course.isEnrolled) return;
    
    setState(() {
      _isEnrolling = true;
    });

    final quizService = Provider.of<QuizService>(context, listen: false);
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    final success = await quizService.enrollInCourse(_course.id);
    
    if (success && mounted) {
      // Get the updated course from service
      final updatedCourse = quizService.getCourse(_course.id);
      if (updatedCourse != null) {
        setState(() {
          _course = updatedCourse;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully enrolled in ${_course.title}! 🎉'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to enroll in course. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isEnrolling = false;
      });
    }
  }

  void _navigateToVideoPlayer(BuildContext context) {
    if (!_course.isEnrolled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enroll in the course to access videos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoUrl: _course.videoUrl,
          courseTitle: _course.title,
        ),
      ),
    );
  }

  void _navigateToQuiz(BuildContext context) {
    if (!_course.isEnrolled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enroll in the course to take quizzes'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final quizService = Provider.of<QuizService>(context, listen: false);
    final quiz = quizService.getQuizByCourse(_course.id);
    
    if (quiz == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quiz not available for this course yet'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(courseId: _course.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_course.title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (_course.isEnrolled)
            IconButton(
              icon: const Icon(Icons.quiz),
              onPressed: () => _navigateToQuiz(context),
              tooltip: 'Take Quiz',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(_course.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: _course.isEnrolled
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 50,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Click to Watch',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 50,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Enroll to Access',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            
            // Course Title
            Text(
              _course.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Instructor
            Text(
              'By ${_course.instructor}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            
            // Course Stats
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(Icons.star, 'Rating', '${_course.rating}', Colors.amber),
                  _buildStatItem(Icons.people, 'Students', '${_course.students}', Colors.blue),
                  _buildStatItem(Icons.timer, 'Duration', '${_course.duration} min', Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Description Section
            const Text(
              'Course Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _course.description,
              style: const TextStyle(
                fontSize: 16, 
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            
            // Categories
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _course.categories.map((category) {
                return Chip(
                  label: Text(
                    category,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.blue[50],
                  side: BorderSide.none,
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            
            // Action Buttons (Different based on enrollment status)
            if (_course.isEnrolled) ...[
              // Enrolled User - Show Watch and Quiz buttons
              Column(
                children: [
                  // Enrollment Status Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[700], size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'You are enrolled in this course',
                                style: TextStyle(
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Access all course content and quizzes',
                                style: TextStyle(
                                  color: Colors.green[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _navigateToVideoPlayer(context),
                          icon: const Icon(Icons.play_arrow, size: 24),
                          label: const Text(
                            'Watch Course',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _navigateToQuiz(context),
                          icon: const Icon(Icons.quiz, size: 24),
                          label: const Text(
                            'Take Quiz',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ] else ...[
              // Not Enrolled - Show enrollment section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 50,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Enroll to Access Course Content',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Get full access to video lessons, quizzes, and earn certificates upon completion',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isEnrolling ? null : () => _enrollInCourse(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isEnrolling
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.school),
                                  SizedBox(width: 8),
                                  Text(
                                    'Enroll Now',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${_course.students} students already enrolled',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Preview Section
              const SizedBox(height: 24),
              const Text(
                'What You\'ll Get:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  _buildFeatureItem(Icons.video_library, 'Video Lessons', 'Access to all course videos'),
                  _buildFeatureItem(Icons.quiz, 'Interactive Quizzes', 'Test your knowledge with quizzes'),
                  _buildFeatureItem(Icons.assignment, 'Practice Exercises', 'Hands-on coding exercises'),
                  _buildFeatureItem(Icons.card_membership, 'Certificate', 'Earn a certificate upon completion'),
                  _buildFeatureItem(Icons.schedule, 'Lifetime Access', 'Learn at your own pace forever'),
                ],
              ),
            ],
            
            // Course Curriculum (for enrolled users)
            if (_course.isEnrolled) ...[
              const SizedBox(height: 32),
              const Text(
                'Course Curriculum',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  _buildCurriculumItem('1', 'Introduction to ${_course.title}', '15 min', true),
                  _buildCurriculumItem('2', 'Getting Started', '25 min', true),
                  _buildCurriculumItem('3', 'Core Concepts', '40 min', false),
                  _buildCurriculumItem('4', 'Advanced Topics', '35 min', false),
                  _buildCurriculumItem('5', 'Final Project', '30 min', false),
                ],
              ),
            ],
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurriculumItem(String number, String title, String duration, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.play_arrow,
              color: isCompleted ? Colors.white : Colors.grey[600],
              size: 12,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isCompleted ? Colors.green : Colors.black87,
              ),
            ),
          ),
          Text(
            duration,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}