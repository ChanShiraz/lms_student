import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/learning_journey/models/lesson.dart';
import 'package:lms_student/features/formative_assessment/view/formative_assessment_page.dart';
import 'package:lms_student/features/formative_assessment/view/formatives_page.dart';
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
              statusIcon: lesson.pMaterialAccessed
                  ? Icon(Icons.check_rounded, color: Colors.green)
                  : null,
            ),
          ),
          InkWell(
            onTap: () {
              Get.toNamed(LessonMaterielPage.routeName, arguments: lesson);
            },
            child: DetailWidget(
              icon: Icons.play_lesson_outlined,
              description: 'Lesson Material',
              statusIcon: lesson.lMaterialAccessed
                  ? Icon(Icons.check_rounded, color: Colors.green)
                  : null,
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

            child: FormativeWidget(
              icon: Icons.document_scanner_outlined,
              description: 'Formative Assessment',
              status: lesson.formativeStatus,
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
    this.statusIcon,
    required this.icon,
    required this.description,
  });
  final Icon? statusIcon;
  final IconData icon;
  final String description;

  @override
  Widget build(BuildContext context) {
    final color = statusIcon != null ? Colors.green : Colors.grey;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 25, color: color),
          SizedBox(width: 10),
          Text(description, style: TextStyle(color: color, fontSize: 16)),
          SizedBox(width: 10),
          statusIcon ?? SizedBox(),
        ],
      ),
    );
  }
}

class FormativeWidget extends StatelessWidget {
  const FormativeWidget({
    super.key,

    required this.icon,
    required this.description,
    required this.status,
  });

  final IconData icon;
  final String description;
  final int status;

  @override
  Widget build(BuildContext context) {
    //final color = statusIcon != null ? Colors.green : Colors.grey;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 25, color: getColor()),
          SizedBox(width: 10),
          Text(description, style: TextStyle(color: getColor(), fontSize: 16)),
          SizedBox(width: 10),
          getTrailingIcon(),
        ],
      ),
    );
  }

  Widget getTrailingIcon() {
    switch (status) {
      case -1:
        return SizedBox();
      case 0:
        return Icon(Icons.check_rounded, color: getColor());
      case 1:
        return Icon(Icons.check_rounded, color: getColor());
      case 2:
        return Icon(Icons.warning_rounded, color: getColor());
      default:
        return SizedBox();
    }
  }

  Color getColor() {
    switch (status) {
      case -1:
        return Colors.grey;
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
