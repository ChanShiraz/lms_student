import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/formative_assessment/controller/formative_assessment_controller.dart';
import 'package:lms_student/features/summative_assessment/controller/summative_assessment_controller.dart';
import 'package:lms_student/features/learning_journey/models/lesson.dart';

class SaLinkPage extends StatelessWidget {
  SaLinkPage({super.key, required this.journey});
  final Journey journey;
  static final routeName = '/salinkpage';
  final controller = Get.find<SummativeAssessmentController>();
  final formKey = GlobalKey<FormState>();
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
                  'Submit evidence of your understanding of cell structure and function. You may include a video, slide deck, blog post, or written summary.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.saLinkTextController,
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
                          controller.submitSummative(
                            journey.dmodSumId,
                            journey.track,
                            journey.courseId,
                            2,
                            journey.accessorId,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 40),
                      ),
                      child: Obx(
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
