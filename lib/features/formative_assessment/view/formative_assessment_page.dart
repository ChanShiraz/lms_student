import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:lms_student/common/custom_appbar.dart';
import 'package:lms_student/common/shimmer_tile.dart';
import 'package:lms_student/features/formative_assessment/widgets/feedback_card.dart';
import 'package:lms_student/features/formative_assessment/widgets/formative_info_card.dart';
import 'package:lms_student/features/formative_assessment/widgets/overview_card.dart';
import 'package:lms_student/features/formative_assessment/widgets/quick_details_card.dart';
import 'package:lms_student/features/formative_assessment/widgets/timeline_card.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/formative_assessment/controller/formative_assessment_controller.dart';
import 'package:lms_student/features/learning_journey/models/lesson.dart';
import 'package:lms_student/features/formative_assessment/view/fa_input_page.dart';
import 'package:lms_student/features/formative_assessment/view/fa_link_page.dart';
import 'package:lms_student/features/learning_journey/view/prior_knowledge_page.dart';
import 'package:lms_student/features/learning_journey/view/quill_page.dart';
import 'package:lms_student/features/summative_assessment/view/summative_assessment_page.dart';

class FormativeAssessmentPage extends StatefulWidget {
  const FormativeAssessmentPage({
    super.key,
    required this.lesson,
    required this.journey,
    required this.formative,
  });
  static final routeName = '/formativeassessmentpage';
  final Lesson lesson;
  final Journey journey;
  final LessonFormative formative;

  @override
  State<FormativeAssessmentPage> createState() =>
      _FormativeAssessmentPageState();
}

class _FormativeAssessmentPageState extends State<FormativeAssessmentPage> {
  final controller = Get.put(FormativeAssessmentController());
  @override
  void initState() {
    controller.fetchFormative(widget.formative.formId);
    super.initState();
  }

  final dateFormat = DateFormat('MM/dd/yyyy');
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Formative Assessment',
        subtitle: '${controller.homeController.userModel.first} · Formative',
      ),
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Wrap(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Assessor: ',
                              style: TextStyle(color: Colors.black54),
                            ),
                            TextSpan(
                              text: widget.journey.assessedBy,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Course: ',
                              style: TextStyle(color: Colors.black54),
                            ),
                            TextSpan(
                              text: widget.journey.courseTitle,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Summative: ',
                              style: TextStyle(color: Colors.black54),
                            ),
                            TextSpan(
                              text: widget.formative.title,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: FormativeInfoCard(
                title: widget.formative.title,
                desc: widget.formative.description,
                type: widget.formative.type,
                link: widget.formative.link,
                text: widget.formative.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(() {
                return controller.fetchingFormative.value ||
                        controller.formative.value != null
                    ? isMobileLayout(context)
                          ? Column(
                              children: [
                                FormativeOverviewCard(
                                  journeyTitle: widget.journey.title,
                                  formative: controller.formative.value,
                                  isLoading:
                                      controller.fetchingFormative.value ||
                                      controller.formative.value == null,
                                ),
                                SizedBox(height: 16),
                                FormativeFeedbackCard(
                                  isLoading: controller.fetchingFormative.value,
                                  submission: controller.formative.value,
                                  journey: widget.journey,
                                  lesson: widget.lesson,
                                  lessonFormative: widget.formative,
                                ),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      FormativeOverviewCard(
                                        journeyTitle: widget.journey.title,
                                        formative: controller.formative.value,
                                        isLoading:
                                            controller
                                                .fetchingFormative
                                                .value ||
                                            controller.formative.value == null,
                                      ),
                                      SizedBox(height: 16),
                                      FormativeFeedbackCard(
                                        isLoading:
                                            controller.fetchingFormative.value,
                                        submission: controller.formative.value,
                                        journey: widget.journey,
                                        lesson: widget.lesson,
                                        lessonFormative: widget.formative,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      FormativeTimelineCard(
                                        isLoading:
                                            controller.fetchingFormative.value,
                                        submission: controller.formative.value,
                                      ),
                                      SizedBox(height: 16),
                                      FormativeQuickDetailsCard(
                                        journey: widget.journey,
                                        task: controller
                                            .formative
                                            .value
                                            ?.description,
                                        isLoading:
                                            controller.fetchingFormative.value,
                                        student:
                                            controller
                                                .homeController
                                                .userModel
                                                .first ??
                                            '',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                    : SubmitWidget(
                        lesson: widget.lesson,
                        journey: widget.journey,
                        formative: widget.formative,
                      );
              }),
            ),
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
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  } else if (status == 2) {
    return Text(
      'Resubmit',
      style: TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }
  return Text('Pending');
}

class SubmitWidget extends StatelessWidget {
  const SubmitWidget({
    super.key,
    required this.lesson,
    required this.journey,
    required this.formative,
  });
  final Lesson lesson;
  final Journey journey;
  final LessonFormative formative;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            formative.description,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),

        SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              Text(
                'Select Submission Type',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 1,
                child: ListTile(
                  onTap: () => Get.toNamed(
                    FaLinkPage.routeName,
                    arguments: [lesson, journey, formative],
                  ),
                  leading: Icon(Icons.link),
                  title: Text('Link'),
                ),
              ),
              SizedBox(height: 10),
              Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 1,
                child: ListTile(
                  onTap: () => Get.toNamed(
                    FaInputPage.routeName,
                    arguments: [lesson, journey, formative],
                  ),
                  leading: Icon(Icons.edit_outlined),
                  title: Text('Direct Input'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
