import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lms_student/features/learning_journey/helpers/rubric_helper.dart';

class ScienceStandardWidget extends StatelessWidget {
  ScienceStandardWidget({super.key});
  final rubricController = Get.find<RubricController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Obx(() {
        return rubricController.fetchingScienceStandard.value
            ? SizedBox()
            : rubricController.scienceStandards.isEmpty
            ? SizedBox.fromSize()
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: rubricController.scienceStandards.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: rubricController.scienceStandards[index].label,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text:
                              " ${rubricController.scienceStandards[index].expectation}",
                        ),
                      ],
                    ),
                  );
                },
              );
      }),
    );
  }
}
