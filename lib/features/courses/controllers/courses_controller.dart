import 'package:get/get.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/home/models/course.dart';
import 'package:lms_student/services/courses_helper.dart';

class CoursesController extends GetxController {
  RxBool loadingCourses = false.obs;
  RxList<Course> courses = <Course>[].obs;
  final homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    //fetchCourses();
  }

  fetchCourses() async {
    loadingCourses.value = true;
    courses.value = await CoursesHelper.fetchStudentCourses(
    userId:   homeController.userModel.userId!,
    learningYear:   homeController.currentLearningYear,
    active: false
    );
    loadingCourses.value = false;
  }
}
