import 'package:flutter/material.dart';
import 'package:lms_student/common/round_container.dart';
import 'package:lms_student/common/shimmer_tile.dart';
import 'package:lms_student/features/formative_assessment/models/formative_submission.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/summative_assessment/widgets/quick_details_card.dart';

class FormativeQuickDetailsCard extends StatelessWidget {
  const FormativeQuickDetailsCard({
    super.key,
    required this.journey,
    required this.task,
    required this.isLoading,
    required this.student,
  });
  final String? task;
  final Journey journey;
  final bool isLoading;
  final String student;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    if (isLoading) {
      return ShimmerTile(width: double.infinity, height: height / 3);
    }
    return RoundContainer(
      color: Colors.white,
      circular: 25,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RoundContainer(
                  color: Colors.grey.shade50,
                  circular: 12,
                  padding: 8,
                  child: Icon(Icons.error_outline, size: 20),
                ),
                SizedBox(width: 10),
                Text(
                  'Quick details',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 12),
            QuickDetailsTile(
              title: 'Student',
              subTitle: student,
              iconData: Icons.person_outline,
            ),

            QuickDetailsTile(
              title: 'Course',
              subTitle: journey.courseTitle,
              iconData: Icons.menu_book_outlined,
            ),
            QuickDetailsTile(
              title: 'Task',
              subTitle: task!,
              iconData: Icons.task_alt_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
