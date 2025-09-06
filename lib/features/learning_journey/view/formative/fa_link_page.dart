import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/learning_journey/controller/formative_assessment_controller.dart';
import 'package:lms_student/features/learning_journey/models/lesson.dart';

class FaLinkPage extends StatelessWidget {
  FaLinkPage({
    super.key,
    required this.lesson,
    required this.journey,
    required this.formative,
  });
  final Lesson lesson;
  final Journey journey;
  final LessonFormative formative;
  static final routeName = '/falinkpage';
  final controller = Get.find<FormativeAssessmentController>();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formative.title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text('Formative Assessment'),
          ],
        ),
        centerTitle: false,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Column(
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
                    TextFormField(
                      controller: controller.faLinkTextController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.link),
                        hint: Text(
                          'Enter Link',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter link!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (formKey.currentState!.validate()) {
                          controller.submitFormative(
                            journey.track,
                            journey.courseId,
                            lesson.lessonId,
                            2,
                            formative
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 40),
                      ),
                      child: Obx(
                        () => controller.submittingFormative.value
                            ? Transform.scale(
                                scale: 0.8,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
