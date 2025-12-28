import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/learning_journey/controller/formative_assessment_controller.dart';
import 'package:lms_student/features/learning_journey/controller/summative_assessment_controller.dart';
import 'package:lms_student/features/learning_journey/models/lesson.dart';

class SaInputPage extends StatelessWidget {
  SaInputPage({super.key, required this.journey});
  static final routeName = '/sainputpage';
  final Journey journey;
  final controller = Get.find<SummativeAssessmentController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              journey.title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text('Summative Assessment'),
          ],
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'Submit evidence of your understanding of cell structure and function. You may include a video, slide deck, blog post, or written summary.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    //borderRadius: BorderRadius.circular(10),
                  ),
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    children: [
                      QuillSimpleToolbar(
                        controller: controller.quillController,
                        config: const QuillSimpleToolbarConfig(),
                      ),
                      Expanded(
                        child: QuillEditor.basic(
                          controller: controller.quillController,
                          config: const QuillEditorConfig(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final plainText = controller.quillController.document
                        .toPlainText()
                        .trim();
                    if (plainText.isNotEmpty) {
                      controller.submitSummative(
                        journey.dmodSumId,
                        journey.track,
                        journey.courseId,
                        4,
                        journey.accessorId,
                      );
                    } else {
                      Get.rawSnackbar(message: 'Please enter text!');
                    }
                  },
                  style: ElevatedButton.styleFrom(minimumSize: Size(200, 40)),
                  child: 
                  //Text('Submit'),
                  Obx(
                    () => controller.submittingSummative.value
                        ? Transform.scale(
                            scale: 0.8,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
