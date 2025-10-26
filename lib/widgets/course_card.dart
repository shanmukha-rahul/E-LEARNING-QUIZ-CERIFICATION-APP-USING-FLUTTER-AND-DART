import 'package:flutter/material.dart';
import '../models/course.dart';
import '../utils/constants.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.cardPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Image with Enrollment Badge
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                      image: DecorationImage(
                        image: NetworkImage(course.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (course.isEnrolled)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                ],
              ),
              
              const SizedBox(width: 16),
              
              // Course Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Instructor
                    Text(
                      'By ${course.instructor}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Course Info
                    Row(
                      children: [
                        _buildInfoItem(
                          Icons.people_outline,
                          '${course.students}',
                        ),
                        const SizedBox(width: 12),
                        _buildInfoItem(
                          Icons.timer_outlined,
                          '${course.duration} min',
                        ),
                        if (course.isEnrolled) ...[
                          const SizedBox(width: 12),
                          _buildInfoItem(
                            Icons.video_library_outlined,
                            '12 lessons',
                          ),
                        ],
                      ],
                    ),
                    
                    // Enrollment Status
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: course.isEnrolled ? Colors.green[50] : Colors.orange[50],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: course.isEnrolled ? Colors.green : Colors.orange,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            course.isEnrolled ? Icons.check_circle : Icons.lock_open,
                            size: 12,
                            color: course.isEnrolled ? Colors.green : Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            course.isEnrolled ? 'Enrolled' : 'Enroll Now',
                            style: TextStyle(
                              fontSize: 12,
                              color: course.isEnrolled ? Colors.green[700] : Colors.orange[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Categories
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: course.categories.take(2).map((category) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              
              // Navigation Arrow
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}