import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/learning_journey/models/lesson.dart';
import 'package:lms_student/features/learning_journey/view/formative/formative_assessment_page.dart';

class FormativesPage extends StatelessWidget {
  const FormativesPage({
    super.key,
    required this.lesson,
    required this.journey,
  });
  static final routeName = '/formativespage';
  final Lesson lesson;
  final Journey journey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lesson.title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text('Formative Assessment'),
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: ListView.builder(
          itemCount: lesson.formatives.length,
          itemBuilder: (context, index) => Card(
            child: ListTile(
              title: Text(
                lesson.formatives[index].title,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(lesson.formatives[index].description),
              trailing: Text(
                'Status : ${status(lesson.formatives[index].status)}',
              ),
              onTap: () {
                Get.toNamed(
                  FormativeAssessmentPage.routeName,
                  arguments: [lesson, journey, lesson.formatives[index]],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String status(int status) {
    switch (status) {
      case -1:
        return 'Not Submitted';
      case 0:
        return 'Submitted';
      case 1:
        return 'Approved';
      case 2:
        return 'Rejected';
      default:
        return '';
    }
  }
}
