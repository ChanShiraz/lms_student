import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:lms_student/features/courses/controllers/courses_controller.dart';
import 'package:lms_student/features/summatives/view/summative_page.dart';
import 'package:lms_student/features/courses/widgets/course_widget.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});
  static final routeName = '/coursespage';

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late CoursesController controller;
  @override
  void initState() {
    controller = Get.put(CoursesController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCourses();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Courses')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Obx(
            () => controller.loadingCourses.value
                ? CircularProgressIndicator()
                : ListView.builder(
                    itemCount: controller.courses.length,
                    itemBuilder: (context, index) => CourseWidget(
                      course: controller.courses[index],
                      onTap: () => Get.toNamed(
                        SummativePage.routeName,
                        arguments: controller.courses[index],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
