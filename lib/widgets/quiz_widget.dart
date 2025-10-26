import 'package:flutter/material.dart';
import '../models/certificate.dart';
import '../utils/helpers.dart';

class CertificateCard extends StatelessWidget {
  final Certificate certificate;
  final VoidCallback onView;
  final VoidCallback onDownload;

  const CertificateCard({
    super.key,
    required this.certificate,
    required this.onView,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final isExpired = AppHelpers.isCertificateExpired(certificate.expiryDate);
    final daysUntilExpiry = AppHelpers.daysUntilExpiry(certificate.expiryDate);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        certificate.courseName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Certificate of Completion',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Certificate Details
            _buildDetailItem(
              Icons.calendar_today,
              'Issued: ${AppHelpers.formatDate(certificate.issuedDate)}',
              context,
            ),
            
            const SizedBox(height: 8),
            
            _buildDetailItem(
              Icons.event_available,
              'Expires: ${AppHelpers.formatDate(certificate.expiryDate)}',
              context,
            ),
            
            const SizedBox(height: 12),
            
            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isExpired ? Colors.red[50] : Colors.green[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isExpired ? Colors.red : Colors.green,
                  width: 1,
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
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onView,
                    icon: const Icon(Icons.remove_red_eye, size: 18),
                    label: const Text('View'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onDownload,
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('Download'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildDetailItem(IconData icon, String text, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}