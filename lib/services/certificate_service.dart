import '../models/certificate.dart';

class CertificateService {
  final List<Certificate> _certificates = [];

  List<Certificate> getUserCertificates(String userId) {
    return _certificates.where((cert) => cert.userId == userId).toList();
  }

  Certificate? generateCertificate(String userId, String courseId, String courseName) {
    final existingCert = _certificates.where((cert) => 
        cert.userId == userId && cert.courseId == courseId);
    
    if (existingCert.isEmpty) {
      final certificate = Certificate(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        courseId: courseId,
        courseName: courseName,
        issuedDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 365 * 2)),
        certificateUrl: 'https://example.com/certificate.jpg',
      );
      
      _certificates.add(certificate);
      return certificate;
    }
    return null;
  }
}