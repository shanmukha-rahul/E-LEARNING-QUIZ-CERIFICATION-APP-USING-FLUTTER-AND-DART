import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/quiz_service.dart';
import '../models/course.dart';
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';
import 'progress_tracker_screen.dart';
import 'certificates_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const ProgressTrackerScreen(),
    const CertificatesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership),
            label: 'Certificates',
          ),
        ],
      ),
    );
  }

  AppBar? _buildAppBar() {
    switch (_currentIndex) {
      case 0:
        return AppBar(
          title: const Text('Courses'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ],
        );
      case 1:
        return AppBar(
          title: const Text('My Progress'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        );
      case 2:
        return AppBar(
          title: const Text('My Certificates'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        );
      default:
        return null;
    }
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() {
    final quizService = Provider.of<QuizService>(context, listen: false);
    setState(() {
      _courses = quizService.getCourses();
    });
  }

  void _refreshCourses() {
    final quizService = Provider.of<QuizService>(context, listen: false);
    setState(() {
      _courses = quizService.getCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _courses.isEmpty
        ? _buildEmptyState()
        : RefreshIndicator(
            onRefresh: () async {
              _refreshCourses();
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                final course = _courses[index];
                return CourseCard(
                  course: course,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailScreen(course: course),
                      ),
                    );
                    _refreshCourses();
                  },
                );
              },
            ),
          );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Courses Available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Check back later for new courses',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}