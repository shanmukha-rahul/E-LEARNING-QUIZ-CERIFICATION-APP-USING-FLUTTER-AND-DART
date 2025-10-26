import 'package:flutter/material.dart';
import '../services/certificate_service.dart';
import '../services/quiz_service.dart';
import '../models/certificate.dart';

class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key});

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  final CertificateService _certificateService = CertificateService();
  final QuizService _quizService = QuizService();
  List<Certificate> _certificates = [];

  @override
  void initState() {
    super.initState();
    _loadCertificates();
  }

  void _loadCertificates() {
    final certificates = _certificateService.getUserCertificates('1');
    setState(() {
      _certificates = certificates;
    });
  }

  void _generateCertificateForCompletedCourses() {
    final quizResults = _quizService.getUserQuizResults('1');
    final courses = _quizService.getCourses();
    
    for (var result in quizResults) {
      if (result.passed) {
        final course = courses.firstWhere(
          (course) => course.id == result.quizId,
          orElse: () => courses.first,
        );
        
        final existingCert = _certificates.where((cert) => cert.courseId == result.quizId);
        if (existingCert.isEmpty) {
          final newCertificate = _certificateService.generateCertificate(
            '1', 
            result.quizId, 
            course.title
          );
          if (newCertificate != null) {
            setState(() {
              _certificates.add(newCertificate);
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Certificates'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _generateCertificateForCompletedCourses();
              _loadCertificates();
            },
          ),
        ],
      ),
      body: _certificates.isEmpty
          ? _buildEmptyState(context)
          : _buildCertificatesList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final quizResults = _quizService.getUserQuizResults('1');
    final passedQuizzes = quizResults.where((result) => result.passed).toList();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.card_membership_outlined,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            const Text(
              'No Certificates Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Complete courses and pass quizzes to earn certificates',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            
            if (passedQuizzes.isNotEmpty) ...[
              const SizedBox(height: 32),
              const Text(
                'You have passed quizzes! Generate certificates:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  _generateCertificateForCompletedCourses();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Certificates generated for completed courses!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Generate Certificates'),
              ),
            ] else ...[
              const SizedBox(height: 32),
              const Text(
                'Pass quizzes to unlock certificates',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Take Quizzes'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCertificatesList() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue[50],
          ),
          child: Column(
            children: [
              Text(
                '${_certificates.length}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const Text(
                'Certificates Earned',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _certificates.length,
            itemBuilder: (context, index) {
              final certificate = _certificates[index];
              return _buildCertificateCard(certificate, context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCertificateCard(Certificate certificate, BuildContext context) {
    final isExpired = DateTime.now().isAfter(certificate.expiryDate);
    final daysUntilExpiry = certificate.expiryDate.difference(DateTime.now()).inDays;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isExpired ? Colors.red[50] : Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.card_membership,
                    color: isExpired ? Colors.red : Colors.green,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        certificate.courseName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Certificate of Completion',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildDetailItem(
              Icons.calendar_today,
              'Issued: ${_formatDate(certificate.issuedDate)}',
            ),
            
            const SizedBox(height: 8),
            
            _buildDetailItem(
              Icons.event_available,
              'Expires: ${_formatDate(certificate.expiryDate)}',
            ),
            
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isExpired ? Colors.red[50] : Colors.green[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isExpired ? Colors.red : Colors.green,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isExpired ? Icons.warning : Icons.verified,
                    size: 14,
                    color: isExpired ? Colors.red : Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isExpired ? 'Expired' : 'Valid',
                    style: TextStyle(
                      color: isExpired ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  if (!isExpired) ...[
                    const SizedBox(width: 4),
                    Text(
                      '($daysUntilExpiry days left)',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewCertificate(certificate, context),
                    icon: const Icon(Icons.remove_red_eye, size: 18),
                    label: const Text('View'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _downloadCertificate(certificate, context),
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('Download'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  void _viewCertificate(Certificate certificate, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Certificate: ${certificate.courseName}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.card_membership, size: 60, color: Colors.blue),
                    const SizedBox(height: 16),
                    Text(
                      certificate.courseName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text('Certificate of Completion'),
                    const SizedBox(height: 16),
                    Text('Issued: ${_formatDate(certificate.issuedDate)}'),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              _downloadCertificate(certificate, context);
              Navigator.pop(context);
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  void _downloadCertificate(Certificate certificate, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading certificate for ${certificate.courseName}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}