import 'dart:math';

import 'package:get/get.dart';
import 'package:lms_student/features/grades/controller/grades_controller.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/home/home.dart';
import 'package:lms_student/features/home/models/course.dart';
import 'package:lms_student/services/courses_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoursesController extends GetxController {
  RxBool loadingCourses = false.obs;
  RxList<Course> courses = <Course>[].obs;
  final homeController = Get.find<HomeController>();
  final gradesController = Get.put(GradesController());
  SupabaseClient supabase = Supabase.instance.client;

  fetchCourses() async {
    loadingCourses.value = true;
    courses.value = await CoursesHelper.fetchStudentCourses(
      userId: homeController.userModel.userId!,
      learningYear: homeController.currentLearningYear.value,
      active: false,
    );
    loadingCourses.value = false;
  }

  makeCourseInActive(int scaid, bool value, int acid) async {
   // print('course id $acid');
    try {
      await supabase
          .from('student_course_assignment')
          .update({'active': value ? 1 : 2})
          .eq('scaid', scaid);
      if (value) {
        courses
                .firstWhere((element) => element.scaid == scaid)
                .assignmentActive =
            1;
      } else {
        courses
                .firstWhere((element) => element.scaid == scaid)
                .assignmentActive =
            2;
        increaseSummativeDate(acid);
      }
      courses.refresh();
      homeController.fetchJournies();
      homeController.fetchStudentCourses();

      gradesController.getGrades();
    } catch (e) {
      print('Error inactivating course $e');
    }
  }

  increaseSummativeDate(int acid) async {
    try {
      final response = await supabase
          .from('alt_proficiency_path_assignment')
          .select('dmod_sum_id, due_date')
          .eq('userid', homeController.userModel.userId!)
          .eq('a_cid', acid);

      for (var element in response) {
        final dumSumId = element['dmod_sum_id'];
        final currentDueDate = DateTime.parse(element['due_date']);

        final submission = await supabase
            .from('summative_student_submissions')
            .select('subid')
            .eq('dmod_sum_id', dumSumId)
            .eq('userid', homeController.userModel.userId!);

        if (submission.isEmpty) {
          final newDueDate = currentDueDate.add(const Duration(days: 7));
          await supabase
              .from('alt_proficiency_path_assignment')
              .update({'due_date': newDueDate.toIso8601String()})
              .eq('dmod_sum_id', dumSumId);
          homeController.fetchJournies();
          print('Date updated successfull');
        }
      }
    } catch (e) {
      print('Error updating alt_proficiency_path_assignment due date $e');
    }
  }
}
