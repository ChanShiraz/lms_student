import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lms_student/features/learning_journey/helpers/rubric_helper.dart';
import 'package:lms_student/features/learning_journey/view/summative/widgets/loading_widget.dart';

class CompetencyWidget extends StatelessWidget {
  CompetencyWidget({super.key});
  final rubricController = Get.find<RubricController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => rubricController.fetchingCompetencices.value
          ? TextShimmer()
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    'Competency and Standard',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 10),
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
