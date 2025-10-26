import '../models/quiz.dart';
import '../models/course.dart';
import '../models/quiz_attempts.dart';
import './quiz_attempt_service.dart';
import './local_storage_service.dart';

class QuizService {
  // Singleton instance
  static final QuizService _instance = QuizService._internal();
  
  factory QuizService() {
    return _instance;
  }
  
  QuizService._internal() {
    _initializeData();
  }

  final QuizAttemptService _attemptService = QuizAttemptService();
  List<Course> _courses = [];
  final List<Quiz> _quizzes = [];
  Map<String, bool> _enrollmentStatus = {};

  void _initializeData() {
    // Initialize courses with NO courses enrolled by default
    _courses = [
      Course(
        id: '1',
        title: 'Flutter Development',
        description: 'Learn Flutter from scratch and build beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.',
        instructor: 'Jane Smith',
        rating: 4.8,
        students: 1500,
        imageUrl: 'lib/services/photos/flutterpic.jpg',
        videoUrl: 'lib/services/photos/video_player (Package of the Week).mp4',
        duration: 120,
        categories: ['Mobile', 'Flutter', 'Dart'],
        isEnrolled: false,
      ),
      Course(
        id: '2',
        title: 'Frontend Development',
        description: 'Build cross-platform mobile apps using React Native and JavaScript.',
        instructor: 'John Doe',
        rating: 4.6,
        students: 1200,
        imageUrl: 'lib/services/photos/frontendpic.jpg',
        videoUrl: 'lib/services/photos/Frontend web development - a complete overview.mp4',
        duration: 90,
        categories: ['Mobile', 'React', 'JavaScript'],
        isEnrolled: false,
      ),
      Course(
        id: '3',
        title: 'Java Programming',
        description: 'Master Java programming language and build robust applications. Learn object-oriented programming, data structures, and advanced Java concepts.',
        instructor: 'Mike Johnson',
        rating: 4.7,
        students: 2200,
        imageUrl: 'lib/services/photos/javapic.jpg',
        videoUrl: 'lib/services/photos/Java in 100 Seconds.mp4',
        duration: 150,
        categories: ['Programming', 'Java', 'Backend'],
        isEnrolled: false,
      ),
      Course(
        id: '4',
        title: 'Python for Beginners',
        description: 'Learn Python programming from scratch. Perfect for beginners to start their coding journey with one of the most popular programming languages.',
        instructor: 'Sarah Wilson',
        rating: 4.9,
        students: 3000,
        imageUrl: 'lib/services/photos/pythonpic.jpg',
        videoUrl: 'lib/services/photos/I Create Dashboard in One Minute using Python _ Python for beginners _ #python #coding #programming.mp4',
        duration: 100,
        categories: ['Programming', 'Python', 'Data Science'],
        isEnrolled: false,
      ),
    ];

    // Load enrollment status from local storage
    _loadEnrollmentStatus();

    // Initialize quizzes for ALL courses
    _quizzes.addAll([
      // Flutter Development Quiz
      Quiz(
        id: '1',
        courseId: '1',
        title: 'Flutter Development Quiz',
        description: 'Test your understanding of Flutter and Dart programming concepts.',
        timeLimit: 30,
        passingScore: 70,
        questions: [
          Question(
            id: '1',
            question: 'What is Flutter primarily used for?',
            options: [
              'Backend development',
              'Mobile app development',
              'Data analysis',
              'Game development',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
          Question(
            id: '2',
            question: 'Which programming language does Flutter use?',
            options: [
              'JavaScript',
              'Python',
              'Dart',
              'Java',
            ],
            correctAnswerIndex: 2,
            points: 1,
          ),
          Question(
            id: '3',
            question: 'What is the main advantage of Flutter?',
            options: [
              'Single codebase for multiple platforms',
              'Only works on Android',
              'Requires separate code for iOS and Android',
              'No hot reload feature',
            ],
            correctAnswerIndex: 0,
            points: 1,
          ),
          Question(
            id: '4',
            question: 'What is Hot Reload in Flutter?',
            options: [
              'A feature to restart the app completely',
              'Instantly see code changes without losing app state',
              'A debugging tool for network requests',
              'A feature to update app on app stores',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
          Question(
            id: '5',
            question: 'Which widget is used for layout in Flutter?',
            options: [
              'Container',
              'Widget',
              'Layout',
              'View',
            ],
            correctAnswerIndex: 0,
            points: 1,
          ),
          Question(
            id: '6',
            question: 'What is a Widget in Flutter?',
            options: [
              'A build configuration',
              'A UI component',
              'A database table',
              'A network request',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
          Question(
            id: '7',
            question: 'Which command is used to create a new Flutter project?',
            options: [
              'flutter new project',
              'flutter create',
              'flutter start',
              'flutter init',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
          Question(
            id: '8',
            question: 'What is the root widget in a Flutter app?',
            options: [
              'MaterialApp',
              'MainWidget',
              'RootApp',
              'AppContainer',
            ],
            correctAnswerIndex: 0,
            points: 1,
          ),
          Question(
            id: '9',
            question: 'Which widget provides material design components?',
            options: [
              'CupertinoApp',
              'MaterialApp',
              'WidgetsApp',
              'DesignApp',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
          Question(
            id: '10',
            question: 'How do you handle state in Flutter?',
            options: [
              'Using StatefulWidget',
              'Using StatelessWidget only',
              'Using HTML',
              'Using JavaScript',
            ],
            correctAnswerIndex: 0,
            points: 1,
          ),
        ],
      ),

      // Frontend Development Quiz
      Quiz(
        id: '2',
        courseId: '2',
        title: 'Frontend Development Quiz',
        description: 'Test your knowledge of frontend web development concepts.',
        timeLimit: 25,
        passingScore: 70,
        questions: [
          Question(
            id: '1',
            question: 'What does HTML stand for?',
            options: [
              'Hyper Text Markup Language',
              'High Tech Modern Language',
              'Hyper Transfer Markup Language',
              'Home Tool Markup Language',
            ],
            correctAnswerIndex: 0,
            points: 1,
          ),
          Question(
            id: '2',
            question: 'Which CSS property is used to change text color?',
            options: [
              'text-color',
              'font-color',
              'color',
              'text-style',
            ],
            correctAnswerIndex: 2,
            points: 1,
          ),
          Question(
            id: '3',
            question: 'What is JavaScript primarily used for?',
            options: [
              'Styling web pages',
              'Adding interactivity to web pages',
              'Creating database schemas',
              'Server configuration',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
          Question(
            id: '4',
            question: 'Which framework is used for building user interfaces in JavaScript?',
            options: [
              'Django',
              'React',
              'Laravel',
              'Spring',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
          Question(
            id: '5',
            question: 'What does CSS stand for?',
            options: [
              'Computer Style Sheets',
              'Creative Style System',
              'Cascading Style Sheets',
              'Colorful Style Sheets',
            ],
            correctAnswerIndex: 2,
            points: 1,
          ),
          Question(
            id: '6',
            question: 'Which HTML tag is used for the largest heading?',
            options: [
              '<heading>',
              '<h1>',
              '<head>',
              '<h6>',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
          Question(
            id: '7',
            question: 'What is the purpose of media queries in CSS?',
            options: [
              'To play media files',
              'To create responsive designs',
              'To optimize images',
              'To add animations',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
          Question(
            id: '8',
            question: 'Which JavaScript keyword is used to declare a variable?',
            options: [
              'var',
              'variable',
              'int',
              'string',
            ],
            correctAnswerIndex: 0,
            points: 1,
          ),
          Question(
            id: '9',
            question: 'What is the box model in CSS?',
            options: [
              'A way to create 3D effects',
              'A layout concept with margin, border, padding, and content',
              'A method for organizing code',
              'A tool for color selection',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
          Question(
            id: '10',
            question: 'Which method is used to select an element by ID in JavaScript?',
            options: [
              'document.querySelector()',
              'document.getElementById()',
              'document.findElement()',
              'document.selectElement()',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
        ],
      ),

      // Java Programming Quiz
      Quiz(
        id: '3',
        courseId: '3',
        title: 'Java Programming Quiz',
        description: 'Test your Java programming knowledge and concepts.',
        timeLimit: 35,
        passingScore: 70,
        questions: [
          Question(
            id: '1',
            question: 'What is Java primarily known for?',
            options: [
              'Platform independence - Write Once Run Anywhere',
              'Being the fastest programming language',
              'Only working on Windows',
              'Not having object-oriented features',
            ],
            correctAnswerIndex: 0,
            points: 1,
          ),
          Question(
            id: '2',
            question: 'Which company originally developed Java?',
            options: [
              'Microsoft',
              'Apple',
              'Sun Microsystems',
              'Google',
            ],
            correctAnswerIndex: 2,
            points: 1,
          ),
          Question(
            id: '3',
            question: 'What is the extension of a Java source file?',
            options: [
              '.java',
              '.class',
              '.js',
              '.jav',
            ],
            correctAnswerIndex: 0,
            points: 1,
          ),
          Question(
            id: '4',
            question: 'Which keyword is used to inherit a class in Java?',
            options: [
              'implements',
              'inherits',
              'extends',
              'super',
            ],
            correctAnswerIndex: 2,
            points: 1,
          ),
          Question(
            id: '5',
            question: 'What is JVM?',
            options: [
              'Java Virtual Machine',
              'Java Variable Method',
              'Java Visual Manager',
              'Java Version Manager',
            ],
            correctAnswerIndex: 0,
            points: 1,
          ),
          Question(
            id: '6',
            question: 'Which data type is used to store true/false values in Java?',
            options: [
              'boolean',
              'int',
              'String',
              'char',
            ],
            correctAnswerIndex: 0,
            points: 1,
          ),
          Question(
            id: '7',
            question: 'What is the default value of a boolean variable in Java?',
            options: [
              'true',
              'false',
              'null',
              '0',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
          Question(
            id: '8',
            question: 'Which method is the entry point of a Java application?',
            options: [
              'start()',
              'main()',
              'execute()',
              'run()',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
          Question(
            id: '9',
            question: 'What is the purpose of the "final" keyword in Java?',
            options: [
              'To make a variable constant',
              'To indicate the last method in a class',
              'To create final classes only',
              'To mark the end of a program',
            ],
            correctAnswerIndex: 0,
            points: 1,
          ),
          Question(
            id: '10',
            question: 'Which collection class allows duplicate elements?',
            options: [
              'Set',
              'List',
              'Map',
              'Queue',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
        ],
      ),

      // Python for Beginners Quiz
      Quiz(
        id: '4',
        courseId: '4',
        title: 'Python Programming Quiz',
        description: 'Test your basic Python programming knowledge.',
        timeLimit: 20,
        passingScore: 70,
        questions: [
          Question(
            id: '1',
            question: 'Python is an interpreted language. What does this mean?',
            options: [
              'It compiles to machine code',
              'It executes code line by line',
              'It only works on specific operating systems',
              'It requires a special compiler',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
          Question(
            id: '2',
            question: 'Which of the following is used to define a function in Python?',
            options: [
              'function',
              'def',
              'define',
              'func',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
          Question(
            id: '3',
            question: 'What will be the output of: print(2 ** 3)',
            options: [
              '6',
              '8',
              '9',
              '23',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
          Question(
            id: '4',
            question: 'Which data type is mutable in Python?',
            options: [
              'tuple',
              'string',
              'list',
              'int',
            ],
            correctAnswerIndex: 2,
            points: 1,
          ),
          Question(
            id: '5',
            question: 'What is the correct way to create a list in Python?',
            options: [
              'list = (1, 2, 3)',
              'list = [1, 2, 3]',
              'list = {1, 2, 3}',
              'list = <1, 2, 3>',
            ],
            correctAnswerIndex: 1,
            points: 1,
          ),
          Question(
            id: '6',
            question: 'Which keyword is used for looping in Python?',
            options: [
              'for',
              'loop',
              'while',
              'repeat',
            ],
            correctAnswerIndex: 0,
            points: 1,
          ),
          Question(
            id: '7',
            question: 'What does the len() function do?',
            options: [
              'Returns the length of an object',
              'Converts to lowercase',
              'Rounds a number',
              'Creates a new list',
            ],
            correctAnswerIndex: 0,
            points: 1,
          ),
          Question(
            id: '8',
            question: 'How do you start reading a file in Python?',
            options: [
              'open_file()',
              'read_file()',
              'open()',
              'file_open()',
            ],
            correctAnswerIndex: 2,
            points: 1,
          ),
          Question(
            id: '9',
            question: 'What is the output of: "hello"[-1]',
            options: [
              'h',
              'e',
              'l',
              'o',
            ],
            correctAnswerIndex: 3,
            points: 1,
          ),
          Question(
            id: '10',
            question: 'Which module is used for mathematical operations?',
            options: [
              'math',
              'calc',
              'numpy',
              'calculate',
            ],
            correctAnswerIndex: 0,
            points: 1,
          ),
        ],
      ),
    ]);
  }

  // Load enrollment status from local storage
  Future<void> _loadEnrollmentStatus() async {
    _enrollmentStatus = await LocalStorageService.loadEnrolledCourses();
    _applyEnrollmentStatusToCourses();
  }

  // Apply saved enrollment status to courses
  void _applyEnrollmentStatusToCourses() {
    for (int i = 0; i < _courses.length; i++) {
      final course = _courses[i];
      final isEnrolled = _enrollmentStatus[course.id] ?? false;
      if (isEnrolled != course.isEnrolled) {
        _courses[i] = course.copyWith(isEnrolled: isEnrolled);
      }
    }
  }

  // Save enrollment status to local storage
  Future<void> _saveEnrollmentStatus() async {
    // Update enrollment status map
    for (var course in _courses) {
      _enrollmentStatus[course.id] = course.isEnrolled;
    }
    await LocalStorageService.saveEnrolledCourses(_enrollmentStatus);
  }

  // Get all courses
  List<Course> getCourses() => List<Course>.from(_courses);
  
  // Get specific course by ID
  Course? getCourse(String id) {
    try {
      return _courses.firstWhere((course) => course.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Get quiz by course ID
  Quiz? getQuizByCourse(String courseId) {
    try {
      print('🔍 Looking for quiz with courseId: $courseId');
      final quiz = _quizzes.firstWhere((quiz) => quiz.courseId == courseId);
      print('✅ Found quiz: ${quiz.title} with ${quiz.questions.length} questions');
      return quiz;
    } catch (e) {
      print('❌ No quiz found for courseId: $courseId');
      print('Available quizzes:');
      for (var quiz in _quizzes) {
        print('  - Quiz ID: ${quiz.id}, Course ID: ${quiz.courseId}, Title: ${quiz.title}');
      }
      return null;
    }
  }

  // Enroll in course - properly update the course in the list and save to storage
  Future<bool> enrollInCourse(String courseId) async {
    try {
      final courseIndex = _courses.indexWhere((course) => course.id == courseId);
      if (courseIndex != -1) {
        final course = _courses[courseIndex];
        
        // Only enroll if not already enrolled
        if (course.isEnrolled) {
          print('ℹ️ Course ${course.title} is already enrolled');
          return true; // Already enrolled
        }
        
        // Create a new course object with enrolled status
        final enrolledCourse = course.copyWith(
          isEnrolled: true,
          students: course.students + 1,
        );
        
        // Update the course in the list
        _courses[courseIndex] = enrolledCourse;
        
        // Save to local storage
        await _saveEnrollmentStatus();
        
        print('✅ Successfully enrolled in course: ${course.title}');
        return true;
      }
      print('❌ Course not found with ID: $courseId');
      return false;
    } catch (e) {
      print('❌ Error enrolling in course: $e');
      return false;
    }
  }

  // Submit quiz with attempt tracking
  QuizAttempt submitQuiz(Quiz quiz, Map<int, int> answers, int timeTaken, String userId) {
    print('📝 Submitting quiz: ${quiz.title}');
    
    int correctAnswers = 0;
    int totalQuestions = quiz.questions.length;
    
    // Calculate correct answers
    for (int i = 0; i < totalQuestions; i++) {
      final userAnswer = answers[i];
      final correctAnswer = quiz.questions[i].correctAnswerIndex;
      
      if (userAnswer != null && userAnswer == correctAnswer) {
        correctAnswers++;
      }
    }
    
    // Calculate score
    double percentage = (correctAnswers / totalQuestions) * 100;
    bool passed = percentage >= quiz.passingScore;
    
    print('📊 Quiz Results:');
    print('  - Correct: $correctAnswers/$totalQuestions');
    print('  - Score: ${percentage.round()}%');
    print('  - Passed: $passed');
    print('  - Time taken: ${timeTaken}s');
    
    final attempt = _attemptService.addAttempt(
      userId: userId,
      quizId: quiz.id,
      courseId: quiz.courseId,
      score: percentage.round(),
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      timeTaken: timeTaken,
      passed: passed,
    );

    return attempt;
  }

  // Get user quiz results (for progress tracker)
  List<QuizAttempt> getUserQuizResults(String userId) {
    return _attemptService.getUserAttempts(userId);
  }

  // Get quiz attempts for specific quiz
  List<QuizAttempt> getQuizAttempts(String userId, String quizId) {
    return _attemptService.getQuizAttempts(userId, quizId);
  }

  // Check if user can attempt quiz
  bool canAttemptQuiz(String userId, String quizId) {
    return _attemptService.getRemainingAttempts(userId, quizId) > 0;
  }

  // Get remaining attempts
  int getRemainingAttempts(String userId, String quizId) {
    return _attemptService.getRemainingAttempts(userId, quizId);
  }

  // Check if quiz is passed
  bool isQuizPassed(String userId, String quizId) {
    return _attemptService.isQuizPassed(userId, quizId);
  }

  // Get all attempts sorted by date
  List<QuizAttempt> getAllAttemptsSorted(String userId) {
    return _attemptService.getAllAttemptsSorted(userId);
  }

  // Get enrolled courses only
  List<Course> getEnrolledCourses() {
    return _courses.where((course) => course.isEnrolled).toList();
  }

  // Check if user is enrolled in course
  bool isEnrolledInCourse(String courseId) {
    try {
      final course = _courses.firstWhere((course) => course.id == courseId);
      return course.isEnrolled;
    } catch (e) {
      return false;
    }
  }

  // Get course progress (mock implementation)
  double getCourseProgress(String courseId, String userId) {
    final attempts = getQuizAttempts(userId, courseId);
    if (attempts.isNotEmpty) {
      final latestAttempt = attempts.last;
      return latestAttempt.passed ? 1.0 : 0.5;
    }
    return 0.0;
  }

  // Clear all enrollment data (for testing)
  Future<void> clearEnrollmentData() async {
    await LocalStorageService.clearEnrollmentData();
    // Reset all courses to not enrolled
    for (int i = 0; i < _courses.length; i++) {
      _courses[i] = _courses[i].copyWith(isEnrolled: false);
    }
  }

  // Debug method to print all quizzes
  void printAllQuizzes() {
    print('=== ALL QUIZZES ===');
    for (var quiz in _quizzes) {
      print('Quiz ID: ${quiz.id}');
      print('Course ID: ${quiz.courseId}');
      print('Title: ${quiz.title}');
      print('Questions: ${quiz.questions.length}');
      print('---');
    }
    print('===================');
  }

  // Debug method to print all courses
  void printAllCourses() {
    print('=== ALL COURSES ===');
    for (var course in _courses) {
      print('Course ID: ${course.id}');
      print('Title: ${course.title}');
      print('Enrolled: ${course.isEnrolled}');
      print('---');
    }
    print('===================');
  }
}


