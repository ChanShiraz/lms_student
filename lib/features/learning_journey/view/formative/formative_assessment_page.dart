import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/learning_journey/controller/formative_assessment_controller.dart';
import 'package:lms_student/features/learning_journey/models/lesson.dart';
import 'package:lms_student/features/learning_journey/view/formative/fa_input_page.dart';
import 'package:lms_student/features/learning_journey/view/formative/fa_link_page.dart';
import 'package:lms_student/features/learning_journey/view/prior_knowledge_page.dart';
import 'package:lms_student/features/learning_journey/view/quill_page.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.formative.title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text('Formative Assessment'),
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Obx(() {
          return controller.fetchingFormative.value
              ? Center(child: CircularProgressIndicator())
              : controller.formative.value != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        widget.formative.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Formative Assessment Info',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Submitted date
                    Row(
                      children: [
                        Text(
                          'Submitted:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          dateFormat.format(controller.formative.value!.date),
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Assessed date
                    Row(
                      children: [
                        Text(
                          'Assessed:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          controller.formative.value!.assessed != null
                              ? dateFormat.format(
                                  controller.formative.value!.assessed!,
                                )
                              : 'N/A',
                          style: TextStyle(fontSize: 16, color: Colors.blue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Assessment status
                    Row(
                      children: [
                        Text(
                          'Assessment:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        assessmentWidget(controller.formative.value!.status),
                        // Text(
                        //   controller.formative.value!.status != 0
                        //       ? controller.formative.value!.status.toString()
                        //       : 'Pending',
                        //   style: TextStyle(fontSize: 16, color: Colors.blue),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // View link
                    Row(
                      children: [
                        Text(
                          'View My Formative:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            if (controller.formative.value!.type == 2 &&
                                controller
                                    .formative
                                    .value!
                                    .pathLink
                                    .isNotEmpty) {
                              launchMyUrl(controller.formative.value!.pathLink);
                            } else if (controller.formative.value!.type == 4) {
                              Get.toNamed(
                                QuillPage.routeName,
                                arguments: [
                                  controller.formative.value!.text!,
                                  widget.lesson.title,
                                ],
                              );
                            }
                          },
                          icon: Icon(
                            Icons.open_in_new,
                            size: 18,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    controller.formative.value!.status == 2 ||
                            controller.formative.value!.status == 1
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Feedback By ${controller.formative.value!.assessBy}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : SizedBox(),
                    controller.formative.value!.status == 2 &&
                            controller.formative.value!.comment != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Card(
                              elevation: 0.5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Expanded(
                                  child: Text(
                                    controller.formative.value!.comment!,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    controller.formative.value!.status == 2
                        ? Column(
                            children: [
                              Material(
                                borderRadius: BorderRadius.circular(10),
                                elevation: 1,
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  tileColor: Colors.orange.shade200,
                                  onTap: () => Get.toNamed(
                                    FaLinkPage.routeName,
                                    arguments: [
                                      widget.lesson,
                                      widget.journey,
                                      widget.formative,
                                    ],
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  tileColor: Colors.orange.shade200,
                                  onTap: () => Get.toNamed(
                                    FaInputPage.routeName,
                                    arguments: [
                                      widget.lesson,
                                      widget.journey,
                                      widget.formative,
                                    ],
                                  ),
                                  leading: Icon(Icons.edit_outlined),
                                  title: Text('Direct Input'),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ],
                )
              : SubmitWidget(
                  lesson: widget.lesson,
                  journey: widget.journey,
                  formative: widget.formative,
                );
        }),
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
