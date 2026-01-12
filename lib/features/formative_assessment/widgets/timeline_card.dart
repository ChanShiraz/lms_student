import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lms_student/common/round_container.dart';
import 'package:lms_student/common/shimmer_tile.dart';
import 'package:lms_student/features/formative_assessment/models/formative_submission.dart';
import 'package:lms_student/features/summative_assessment/widgets/timeline_card.dart';

class FormativeTimelineCard extends StatelessWidget {
  const FormativeTimelineCard({
    super.key,
    required this.isLoading,
    required this.submission,
  });

  final bool isLoading;
  final FormativeSubmission? submission;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MM/dd/yyyy');
    final height = MediaQuery.of(context).size.height;

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
                  child: Icon(Icons.done_rounded, size: 20),
                ),
                SizedBox(width: 10),
                Text(
                  'Assessment timeline',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TimelineItem(
              title: 'Submitted',
              date: submission != null
                  ? dateFormat.format(submission!.date)
                  : 'N/A',
              iconData: Icons.text_snippet_outlined,
            ),

            TimelineItem(
              title: 'Assessed',
              date: submission != null && submission!.assessed != null
                  ? dateFormat.format(submission!.assessed!)
                  : 'N/A',
              iconData: Icons.domain_verification_rounded,
            ),

            TimelineItem(
              title: 'Status',
              date: getStatus(submission!.status),
              isStatus: true,
              iconData: Icons.security,
            ),
          ],
        ),
      ),
    );
  }

  String getStatus(int status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Approved';
      case 2:
        return 'Resubmit';
      default:
        return '';
    }
  }
}
