import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:lms_student/common/round_container.dart';
import 'package:lms_student/common/shimmer_tile.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/summative_assessment/models/summative_submission.dart';
import 'package:lms_student/features/learning_journey/view/prior_knowledge_page.dart';
import 'package:lms_student/features/learning_journey/view/quill_page.dart';
import 'package:lms_student/features/summative_assessment/widgets/materials_widget.dart';
import 'package:lms_student/features/summative_assessment/controller/summative_assessment_controller.dart';
import 'package:lms_student/features/summative_assessment/view/summative_assessment_page.dart';
import 'package:lms_student/features/summative_assessment/widgets/expanded_tile.dart';
import 'package:lms_student/features/summative_assessment/widgets/rubric_information_tile.dart';
import 'package:lms_student/features/summative_assessment/widgets/summative_resource_tile.dart';
import 'package:lms_student/features/summatives/controller/summative_controller.dart';
import 'package:lms_student/features/summatives/widgets/summative_widget.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({
    super.key,
    required this.controller,
    required this.journey,
  });
  final SummativeAssessmentController controller;
  final Journey journey;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final dateFormat = DateFormat('MM/dd/yyyy');
    return Obx(() {
      return controller.fetchingSubSummative.value ||
              controller.summativeLesson.value == null
          ? ShimmerTile(width: double.infinity, height: height / 2.5)
          : controller.summativeLesson.value != null
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
                                  StatusWidget(
                                    submission:
                                        controller.submittedSummative.value,
                                  ),
                                  OverviewStatTile(
                                    title: 'Submitted',
                                    value:
                                        controller.submittedSummative.value !=
                                            null
                                        ? dateFormat.format(
                                            controller
                                                .submittedSummative
                                                .value!
                                                .date,
                                          )
                                        : 'N/A',
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  OverviewStatTile(
                                    title: 'Assessed',
                                    value:
                                        controller.submittedSummative.value !=
                                                null &&
                                            controller
                                                    .submittedSummative
                                                    .value!
                                                    .assessed !=
                                                null
                                        ? dateFormat.format(
                                            controller
                                                .submittedSummative
                                                .value!
                                                .assessed!,
                                          )
                                        : 'N/A',
                                  ),
                                  OverviewStatTile(
                                    title: 'Proficiency',
                                    value: 'METACOGNITION',
                                    badge: true,
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              StatusWidget(
                                submission: controller.submittedSummative.value,
                              ),

                              OverviewStatTile(
                                title: 'Submitted',
                                value:
                                    controller.submittedSummative.value != null
                                    ? dateFormat.format(
                                        controller
                                            .submittedSummative
                                            .value!
                                            .date,
                                      )
                                    : 'N/A',
                              ),
                              OverviewStatTile(
                                title: 'Assessed',
                                value:
                                    controller.submittedSummative.value !=
                                            null &&
                                        controller
                                                .submittedSummative
                                                .value!
                                                .assessed !=
                                            null
                                    ? dateFormat.format(
                                        controller
                                            .submittedSummative
                                            .value!
                                            .assessed!,
                                      )
                                    : 'N/A',
                              ),
                              // OverviewStatTile(
                              //   title: 'Proficiency',
                              //   value: 'METACOGNITION',
                              //   badge: true,
                              // ),
                              ProficiencyWidget(grade: journey.grade),
                            ],
                          ),
                    const SizedBox(height: 16),
                    RubricInformationTile(),
                    const SizedBox(height: 8),
                    SummativeResourceTile(),
                    // const SizedBox(height: 8),
                    // ApprovedMaterialList(controller: controller),
                  ],
                ),
              ),
            )
          : SizedBox();
    });
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
        controller.submittedSummative.value != null
            ? ElevatedButton.icon(
                onPressed: () {
                  if (controller.submittedSummative.value!.type == 2 &&
                      controller
                          .submittedSummative
                          .value!
                          .pathLink
                          .isNotEmpty) {
                    launchMyUrl(controller.submittedSummative.value!.pathLink);
                  } else if (controller.submittedSummative.value!.type == 4) {
                    Get.toNamed(
                      QuillPage.routeName,
                      arguments: [
                        controller.submittedSummative.value!.text!,
                        journey.title,
                      ],
                    );
                  }
                },
                icon: const Icon(Icons.remove_red_eye),
                label: const Text('View Summative'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}

class OverviewStatTile extends StatelessWidget {
  final String title;
  final String value;
  final bool success;
  final bool badge;

  const OverviewStatTile({
    super.key,
    required this.title,
    required this.value,
    this.success = false,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: RoundContainer(
          height: 75,
          color: Colors.grey.shade50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              badge
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        if (success)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16,
                          ),
                        if (success) const SizedBox(width: 4),
                        Text(
                          value,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key, required this.submission});
  final SummativeSubmission? submission;

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
                      submission!.status == 1
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            )
                          : submission!.status == 2
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
                      assessmentWidget(submission!.status),
                    ],
                  )
                : Text('N/A'),
          ],
        ),
      ),
    );
  }
}

class ProficiencyWidget extends StatelessWidget {
  const ProficiencyWidget({super.key, required this.grade});
  final double? grade;

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
              'Proficiency',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            buildGradeWidget(grade),
          ],
        ),
      ),
    );
  }
}

Widget assessmentWidget(int status) {
  if (status == 1) {
    return Text(
      'Approved',
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w500,
        // fontSize: 16,
      ),
    );
  } else if (status == 2) {
    return Text(
      'Resubmit',
      style: TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.w500,
        //fontSize: 16,
      ),
    );
  }
  return Text('Pending', style: TextStyle(fontWeight: FontWeight.w500));
}
