import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:lms_student/common/round_container.dart';
import 'package:lms_student/common/shimmer_tile.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/summative_assessment/controller/summative_assessment_controller.dart';

class QuickDetailsCard extends StatelessWidget {
  QuickDetailsCard({super.key, required this.journey});
  final controller = Get.find<SummativeAssessmentController>();
  final Journey journey;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Obx(
      () => controller.fetchingSummativeLesson.value
          ? ShimmerTile(width: double.infinity, height: height / 3.5)
          : RoundContainer(
              color: Colors.white,
              circular: 25,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RoundContainer(
                          color: Colors.grey.shade50,
                          circular: 12,
                          padding: 8,
                          child: Icon(Icons.error_outline, size: 20),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Quick details',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    QuickDetailsTile(
                      title: 'Student',
                      subTitle: controller.homeController.userModel.first ?? '',
                      iconData: Icons.person_outline,
                    ),

                    QuickDetailsTile(
                      title: 'Course',
                      subTitle: journey.courseTitle,
                      iconData: Icons.menu_book_outlined,
                    ),
                    QuickDetailsTile(
                      title: 'Task',
                      subTitle: controller.summativeLesson.value!.task,
                      iconData: Icons.task_alt_rounded,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class QuickDetailsTile extends StatelessWidget {
  const QuickDetailsTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.iconData,
  });
  final String title;
  final String subTitle;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: RoundContainer(
        circular: 15,
        color: Colors.grey.shade50,
        child: Icon(iconData, color: Colors.black, size: 20),
      ),
      title: Text(title),
      subtitle: Text(
        subTitle,
        style: TextStyle(fontSize: 14, color: Colors.black54),
      ),
    );
  }
}
