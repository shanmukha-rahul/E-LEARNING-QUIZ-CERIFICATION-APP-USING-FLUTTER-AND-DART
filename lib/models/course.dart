class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final double rating;
  final int students;
  final String imageUrl;
  final String videoUrl;
  final int duration;
  final List<String> categories;
  final bool isEnrolled;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    this.rating = 0.0,
    this.students = 0,
    required this.imageUrl,
    required this.videoUrl,
    required this.duration,
    required this.categories,
    this.isEnrolled = false,
  });

  // Convert Course to Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'rating': rating,
      'students': students,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'duration': duration,
      'categories': categories,
      'isEnrolled': isEnrolled,
    };
  }

  // Create Course from Map
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      instructor: json['instructor'],
      rating: json['rating']?.toDouble() ?? 0.0,
      students: json['students'] ?? 0,
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      duration: json['duration'],
      categories: List<String>.from(json['categories']),
      isEnrolled: json['isEnrolled'] ?? false,
    );
  }

  // Create a copy of course with updated enrollment
  Course copyWith({
    bool? isEnrolled,
    int? students,
  }) {
    return Course(
      id: id,
      title: title,
      description: description,
      instructor: instructor,
      rating: rating,
      students: students ?? this.students,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
      duration: duration,
      categories: categories,
      isEnrolled: isEnrolled ?? this.isEnrolled,
    );
  }
}