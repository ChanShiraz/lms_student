import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lms_student/features/courses/controllers/courses_controller.dart';
import 'package:lms_student/features/grades/controller/grades_controller.dart';
import 'package:lms_student/features/grades/models/grade.dart';
import 'package:lms_student/features/grades/widgets/grade_widget.dart';

class GradesPage extends StatefulWidget {
  const GradesPage({super.key});
  static final routeName = '/gradespage';

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  late GradesController controller;
  @override
  void initState() {
    controller = Get.put(GradesController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getGrades();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Grades'), centerTitle: false),
      body: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Obx(
          () => controller.isLoadingCourses.value
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: controller.courses.length,
                  itemBuilder: (context, index) =>
                      GradeWidget(course: controller.courses[index]),
                ),
        ),
      ),
    );
  }
}
