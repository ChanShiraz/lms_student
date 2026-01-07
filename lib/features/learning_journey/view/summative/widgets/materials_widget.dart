import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lms_student/features/learning_journey/controller/summative_assessment_controller.dart';
import 'package:lms_student/features/learning_journey/models/approved_material.dart';
import 'package:lms_student/features/learning_journey/models/resource.dart';
import 'package:lms_student/features/learning_journey/view/summative/widgets/resources_widget.dart';
import 'package:lms_student/features/learning_journey/view/summative/widgets/text_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class ApprovedMaterialList extends StatelessWidget {
  const ApprovedMaterialList({super.key, required this.controller});
  final SummativeAssessmentController controller;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.fetchingResources.value) {
        return SizedBox();
      }

      return ExpansionTile(
        shape: Border(),
        title: Text(
          'Approved Instructional Material',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
        children: [
          controller.approveMat.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.approveMat.length,
                  itemBuilder: (context, index) {
                    return MaterialsWidget(
                      material: controller.approveMat[index],
                    );
                  },
                )
              : Text(
                  'No material attached!',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
        ],
      );
    });
  }
}

class MaterialsWidget extends StatelessWidget {
  const MaterialsWidget({super.key, required this.material});
  final ApprovedMaterial material;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          material.title,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          //style: TextStyle(color: Colors.blue),
        ),
        Text(material.description),
        material.instructions != null
            ? Text(
                'Instructions : ${material.instructions!}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            : SizedBox(),
        SizedBox(height: 10),
        Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 1,
          child: ListTile(
            onTap: () async {
              try {
                await UrlHelper.launch(material.path);
                // debugPrint('link ${assessment.pathLink}');
              } catch (e) {
                Get.rawSnackbar(message: 'Could not launch the link!');
              }
            },
            leading: Icon(Icons.link, color: Colors.blue),
            title: Text(
              'View (${material.type})',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
