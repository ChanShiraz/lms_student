import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:lms_student/common/round_container.dart';
import 'package:lms_student/common/shimmer_tile.dart';
import 'package:lms_student/features/formative_assessment/controller/formative_assessment_controller.dart';
import 'package:lms_student/features/formative_assessment/models/formative_submission.dart';
import 'package:lms_student/features/learning_journey/view/prior_knowledge_page.dart';
import 'package:lms_student/features/learning_journey/view/quill_page.dart';
import 'package:lms_student/features/summative_assessment/view/summative_assessment_page.dart';
import 'package:lms_student/features/summative_assessment/widgets/overview_card.dart';

class FormativeOverviewCard extends StatelessWidget {
  const FormativeOverviewCard({
    super.key,
    required this.journeyTitle,
    required this.formative,
    required this.isLoading,
  });
  final String journeyTitle;
  final FormativeSubmission? formative;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final dateFormat = DateFormat('MM/dd/yyyy');
    return isLoading
        ? ShimmerTile(width: double.infinity, height: height / 3)
        : formative != null
        ? RoundContainer(
            color: Colors.white,
            circular: 25,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  const SizedBox(height: 16),
                  isMobileLayout(context)
                      ? Column(
                          children: [
                            Row(
                              children: [
                                StatusWidget(submission: formative!.status),
                                OverviewStatTile(
                                  title: 'Submitted',
                                  value: dateFormat.format(formative!.date),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                OverviewStatTile(
                                  title: 'Assessed',
                                  value: formative!.assessed != null
                                      ? dateFormat.format(formative!.assessed!)
                                      : 'N/A',
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            StatusWidget(submission: formative!.status),

                            OverviewStatTile(
                              title: 'Submitted',
                              value: dateFormat.format(formative!.date),
                            ),
                            OverviewStatTile(
                              title: 'Assessed',
                              value: formative!.assessed != null
                                  ? dateFormat.format(formative!.assessed!)
                                  : 'N/A',
                            ),
                          ],
                        ),
                ],
              ),
            ),
          )
        : SizedBox();
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            const Text(
              'Overview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            if (formative!.type == 2 && formative!.pathLink.isNotEmpty) {
              print('formative link ${formative!.pathLink}');
              launchMyUrl(formative!.pathLink);
            } else if (formative!.type == 4) {
              Get.toNamed(
                QuillPage.routeName,
                arguments: [formative!.text!, journeyTitle],
              );
            }
          },
          icon: const Icon(Icons.remove_red_eye),
          label: const Text('View My Formative'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key, required this.submission});
  final int? submission;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RoundContainer(
        color: Colors.grey.shade50,
        height: 75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            submission != null
                ? Row(
                    children: [
                      submission == 1
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            )
                          : submission == 2
                          ? Icon(
                              Icons.event_repeat_outlined,
                              color: Colors.orange,
                              size: 16,
                            )
                          : Icon(
                              Icons.pending_outlined,
                              color: Colors.grey,
                              size: 16,
                            ),
                      const SizedBox(width: 4),
                      assessmentWidget(submission!),
                    ],
                  )
                : Text('N/A'),
          ],
        ),
      ),
    );
  }
}
