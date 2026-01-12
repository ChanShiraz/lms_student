import 'package:get/get.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/home/models/course.dart';
import 'package:lms_student/services/courses_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GradesController extends GetxController {
  final coursesHelper = CoursesHelper();
  SupabaseClient supabase = Supabase.instance.client;
  RxList<Course> courses = <Course>[].obs;
  final homeController = Get.find<HomeController>();
  RxBool isLoadingCourses = false.obs;

  getGrades() async {
    isLoadingCourses.value = true;
    courses.value = await CoursesHelper.fetchStudentCourses(
     userId:  homeController.userModel.userId!,
     learningYear:  homeController.currentLearningYear.value,
    );
    isLoadingCourses.value = false;
  }
}
