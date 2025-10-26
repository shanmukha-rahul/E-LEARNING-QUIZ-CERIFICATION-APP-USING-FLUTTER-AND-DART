import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _enrollmentStatusKey = 'course_enrollment_status';

  // Save enrolled courses status
  static Future<void> saveEnrolledCourses(Map<String, bool> enrollmentStatus) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Convert map to JSON string
      final enrollmentJson = <String, String>{};
      enrollmentStatus.forEach((courseId, isEnrolled) {
        enrollmentJson[courseId] = isEnrolled.toString();
      });
      
      // Save as string
      await prefs.setString(_enrollmentStatusKey, enrollmentJson.toString());
      print('💾 Saved enrollment data: $enrollmentJson');
    } catch (e) {
      print('❌ Error saving enrollment data: $e');
    }
  }

  // Load enrolled courses status
  static Future<Map<String, bool>> loadEnrolledCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final enrollmentString = prefs.getString(_enrollmentStatusKey);
      
      if (enrollmentString != null && enrollmentString.isNotEmpty) {
        print('📖 Loading enrollment data: $enrollmentString');
        
        // Parse the string back to map
        final enrollmentMap = <String, bool>{};
        
        // Remove curly braces and split by comma
        final cleanedString = enrollmentString.replaceAll('{', '').replaceAll('}', '');
        final pairs = cleanedString.split(', ');
        
        for (var pair in pairs) {
          final keyValue = pair.split(': ');
          if (keyValue.length == 2) {
            final courseId = keyValue[0].trim();
            final isEnrolled = keyValue[1].trim().toLowerCase() == 'true';
            enrollmentMap[courseId] = isEnrolled;
          }
        }
        
        print('✅ Loaded ${enrollmentMap.length} enrolled courses');
        return enrollmentMap;
      } else {
        print('📖 No enrollment data found in storage');
        return {};
      }
    } catch (e) {
      print('❌ Error loading enrollment data: $e');
      return {};
    }
  }

  // Clear all enrollment data (for testing/reset)
  static Future<void> clearEnrollmentData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_enrollmentStatusKey);
      print('🗑️ Cleared all enrollment data');
    } catch (e) {
      print('❌ Error clearing enrollment data: $e');
    }
  }

  // Get all stored keys (for debugging)
  static Future<void> printAllStoredKeys() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      print('🔑 All stored keys: $keys');
      
      for (var key in keys) {
        final value = prefs.get(key);
        print('   $key: $value');
      }
    } catch (e) {
      print('❌ Error reading stored keys: $e');
    }
  }
}