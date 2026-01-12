import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lms_student/features/learning_journey/helpers/rubric_helper.dart';

class CompetencyWidget extends StatelessWidget {
  CompetencyWidget({super.key});
  final rubricController = Get.find<RubricController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => rubricController.fetchingCompetencices.value
          ? SizedBox()
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: rubricController.competencies.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${rubricController.competencies[index].dpcHeading} :',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${rubricController.competencies[index].dpcDescription}',
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
    );
  }
}
