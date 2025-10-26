class AppConstants {
  // App Information
  static const String appName = 'E-Learning App';
  static const String appVersion = '1.0.0';

  // API Endpoints (Replace with your actual endpoints)
  static const String baseUrl = 'https://api.elearningapp.com';
  static const String loginEndpoint = '/auth/login';
  static const String signupEndpoint = '/auth/signup';
  static const String coursesEndpoint = '/courses';
  static const String quizzesEndpoint = '/quizzes';
  static const String certificatesEndpoint = '/certificates';

  // SharedPreferences Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
  static const String themeKey = 'app_theme';

  // Quiz Constants
  static const int defaultQuizTime = 30; // minutes
  static const int passingScore = 70; // percentage

  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);

  // Colors
  static const int primaryColorValue = 0xFF2196F3;
  static const int secondaryColorValue = 0xFF4CAF50;
  static const int accentColorValue = 0xFFFFC107;
  static const int errorColorValue = 0xFFF44336;
  static const int successColorValue = 0xFF4CAF50;
  static const int warningColorValue = 0xFFFF9800;

  // Text Styles
  static const double headingFontSize = 24.0;
  static const double titleFontSize = 18.0;
  static const double bodyFontSize = 16.0;
  static const double captionFontSize = 14.0;

  // Padding and Margins
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double cardPadding = 12.0;
  static const double buttonPadding = 12.0;

  // Border Radius
  static const double defaultBorderRadius = 8.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;

  // Icons
  static const double defaultIconSize = 24.0;
  static const double largeIconSize = 32.0;
}

class RouteConstants {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String courseDetail = '/course-detail';
  static const String videoPlayer = '/video-player';
  static const String quiz = '/quiz';
  static const String progress = '/progress';
  static const String certificates = '/certificates';
  static const String profile = '/profile';
  static const String settings = '/settings';
}

class AssetConstants {
  static const String logo = 'assets/images/logo.png';
  static const String placeholder = 'assets/images/placeholder.jpg';
  static const String defaultProfile = 'assets/images/default_profile.png';
  static const String certificateTemplate = 'assets/images/certificate_template.png';
  
  // Lottie Animations
  static const String loadingAnimation = 'assets/animations/loading.json';
  static const String successAnimation = 'assets/animations/success.json';
  static const String emptyAnimation = 'assets/animations/empty.json';
}

class ValidationConstants {
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxEmailLength = 100;
}