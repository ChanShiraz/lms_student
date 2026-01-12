import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:lms_student/common/round_container.dart';
import 'package:lms_student/common/shimmer_tile.dart';
import 'package:lms_student/features/summative_assessment/controller/summative_assessment_controller.dart';

class TimelineCard extends StatelessWidget {
  TimelineCard({super.key});
  final controller = Get.find<SummativeAssessmentController>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final dateFormat = DateFormat('MM/dd/yyyy');
    return Obx(
      () => controller.fetchingSubSummative.value
          ? ShimmerTile(width: double.infinity, height: height / 3)
          : RoundContainer(
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
                    SizedBox(height: 16),
                    TimelineItem(
                      title: 'Submitted',
                      date: controller.submittedSummative.value != null
                          ? dateFormat.format(
                              controller.submittedSummative.value!.date,
                            )
                          : 'N/A',
                      iconData: Icons.text_snippet_outlined,
                    ),
                    TimelineItem(
                      title: 'Assessed',
                      date:
                          controller.submittedSummative.value != null &&
                              controller.submittedSummative.value!.assessed !=
                                  null
                          ? dateFormat.format(
                              controller.submittedSummative.value!.assessed!,
                            )
                          : 'N/A',
                      iconData: Icons.domain_verification_rounded,
                    ),
                    TimelineItem(
                      title: 'Status',
                      date: getStatus(),
                      isStatus: true,
                      iconData: Icons.security,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String getStatus() {
    if (controller.submittedSummative.value == null) {
      return 'N/A';
    }
    switch (controller.submittedSummative.value!.status) {
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

class TimelineItem extends StatelessWidget {
  final String title;
  final String date;
  final bool isStatus;
  final IconData iconData;

  const TimelineItem({
    super.key,
    required this.title,
    required this.date,
    this.isStatus = false,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: RoundContainer(
        circular: 15,
        color: Colors.green.withOpacity(0.1),
        child: Icon(iconData, color: Colors.green, size: 20),
      ),
      title: Text(title),
      subtitle: Text(date, style: TextStyle(fontSize: 14, color: Colors.grey)),
    );
  }
}
