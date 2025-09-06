import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lms_student/features/learning_journey/helpers/rubric_helper.dart';
import 'package:lms_student/features/learning_journey/view/summative/widgets/loading_widget.dart';

class NonScienceStandardWidget extends StatelessWidget {
  NonScienceStandardWidget({super.key});
  final rubricController = Get.find<RubricController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Obx(() {
        return rubricController.fetchingScienceStandard.value
            ? TextShimmer(lines: 5)
            : rubricController.nonScienceStandards.isEmpty
            ? SizedBox.shrink()
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: rubricController.nonScienceStandards.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              rubricController.nonScienceStandards[index].label,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text:
                              " ${rubricController.nonScienceStandards[index].description}",
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
