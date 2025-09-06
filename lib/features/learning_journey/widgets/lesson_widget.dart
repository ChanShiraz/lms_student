import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/learning_journey/models/lesson.dart';
import 'package:lms_student/features/learning_journey/view/formative/formative_assessment_page.dart';
import 'package:lms_student/features/learning_journey/view/formative/formatives_page.dart';
import 'package:lms_student/features/learning_journey/view/kwl_page.dart';
import 'package:lms_student/features/learning_journey/view/lesson_materiel_page.dart';
import 'package:lms_student/features/learning_journey/view/prior_knowledge_page.dart';

class LessonWidget extends StatelessWidget {
  const LessonWidget({super.key, required this.lesson, required this.journey});
  final Lesson lesson;
  final Journey journey;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Text(
              lesson.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.toNamed(PriorKnowledgePage.routeName, arguments: lesson);
            },
            child: DetailWidget(
              icon: Icons.person_outline,
              description: 'Prior Knowledge',
            ),
          ),
          InkWell(
            onTap: () {
              Get.toNamed(LessonMaterielPage.routeName, arguments: lesson);
            },
            child: DetailWidget(
              icon: Icons.play_lesson_outlined,
              description: 'Lesson Material',
            ),
          ),
          InkWell(
            onTap: () => Get.toNamed(KwlPage.routeName),
            child: DetailWidget(
              icon: Icons.browse_gallery_outlined,
              description: 'KWL Input',
            ),
          ),
          InkWell(
            onTap: () => Get.toNamed(
              FormativesPage.routeName,
              arguments: [lesson, journey],
            ),

            child: DetailWidget(
              icon: Icons.document_scanner_outlined,
              description: 'Formative Assessment',
            ),
          ),
        ],
      ),
    );
  }
}

class DetailWidget extends StatelessWidget {
  const DetailWidget({
    super.key,
    required this.icon,
    required this.description,
  });
  final IconData icon;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 25, color: Colors.grey),
          SizedBox(width: 10),
          Text(description, style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
