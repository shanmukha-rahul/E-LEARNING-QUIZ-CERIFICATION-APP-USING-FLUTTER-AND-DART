class Certificate {
  final String id;
  final String userId;
  final String courseId;
  final String courseName;
  final DateTime issuedDate;
  final DateTime expiryDate;
  final String certificateUrl;

  Certificate({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.courseName,
    required this.issuedDate,
    required this.expiryDate,
    required this.certificateUrl,
  });
}