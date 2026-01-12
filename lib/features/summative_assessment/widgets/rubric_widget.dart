import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lms_student/features/learning_journey/helpers/rubric_helper.dart';

class RubricWidget extends StatelessWidget {
  RubricWidget({super.key});
  final rubricController = Get.find<RubricController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Obx(() {
        return rubricController.fetchingRubric.value
            ? SizedBox()
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: rubricController.rubrics.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Text(rubricController.rubrics[index]);
                },
              );
      }),
    );
  }
}
