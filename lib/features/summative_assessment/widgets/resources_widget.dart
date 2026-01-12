import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lms_student/features/summative_assessment/controller/summative_assessment_controller.dart';
import 'package:lms_student/features/summative_assessment/models/resource.dart';
import 'package:lms_student/features/summative_assessment/widgets/text_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesList extends StatelessWidget {
  const ResourcesList({
    super.key,
    required this.controller,
    required this.dumSumId,
  });
  final SummativeAssessmentController controller;
  final int dumSumId;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.fetchingResources.value) {
        return CircularProgressIndicator();
      }
      if (controller.fetchingResError.isNotEmpty) {
        Column(
          children: [
            IconButton(
              onPressed: () {
                controller.fetchResources(dumSumId);
              },
              icon: Icon(Icons.refresh),
            ),
            SizedBox(height: 10),
            Text('Error fetching resources, Please try again!'),
          ],
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: controller.resources.length,
        itemBuilder: (context, index) {
          return ResourcesWidget(resource: controller.resources[index]);
        },
      );
    });
  }
}

class ResourcesWidget extends StatelessWidget {
  const ResourcesWidget({super.key, required this.resource});
  final Resource resource;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const Border(),
      title: Text(
        resource.description ?? '',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        //style: TextStyle(color: Colors.blue),
      ),
      children: [
        resource.type == 2
            ? Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 1,
                child: ListTile(
                  onTap: () async {
                    try {
                      await UrlHelper.launch(resource.value);
                      // debugPrint('link ${assessment.pathLink}');
                    } catch (e) {
                      Get.rawSnackbar(message: 'Could not launch the link!');
                    }
                  },
                  leading: Icon(Icons.link, color: Colors.blue),
                  title: Text(
                    'View (Link)',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            : resource.type == 4
            ? Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 1,
                child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => TextDialog(initialText: resource.value),
                    );
                  },
                  leading: Icon(
                    Icons.text_snippet_outlined,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'View (Text)',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            : SizedBox(),
        SizedBox(height: 5),
      ],
    );
  }
}

class UrlHelper {
  static Future<void> launch(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await canLaunchUrl(uri)) {
      throw 'Could not launch $url';
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
