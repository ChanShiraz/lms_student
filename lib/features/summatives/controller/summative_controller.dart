import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/home/controller/home_repo.dart';
import 'package:lms_student/features/home/models/course.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/features/summatives/model/summative.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SummativeController extends GetxController {
  SupabaseClient supabase = Supabase.instance.client;

  final Course course;
  final HomeController homeController = Get.find<HomeController>();

  SummativeController({required this.course});
  RxBool fetchingJournies = false.obs;
  RxList<Journey> journies = <Journey>[].obs;
  final homeRepo = HomeRepo();

  Future<void> fetchJournies(int acid) async {
    fetchingJournies.value = true;
    //fetchingJourniesError.value = '';
    journies.clear();

    try {
      final response = await supabase
          .from('alt_proficiency_path_assignment')
          .select(
            'a_cid, dmod_sum_id, due_date, completed_date,'
            'alt_mod_summatives(image,title),'
            'alt_courses(title1,course_type,userid_assigned)',
          )
          .eq('a_cid', acid)
          .eq('userid', homeController.userModel.userId!)
          .eq('active', 1)
          .eq('alt_courses.alyid', homeController.currentLearningYear)
          .order('due_date', ascending: true);

      /// 3️⃣ Filter based on active courses
      for (final element in response) {
        final status = await homeRepo.getStatus(
          userId: homeController.userModel.userId!,
          learningYear: homeController.currentLearningYear,
          dmodSumId: element['dmod_sum_id'],
        );

        final journey = Journey.fromMap(
          element: element,
          status: status,
          now: DateTime.now(),
        );
        journies.add(journey);
      }
    } catch (e) {
      //  fetchingJourniesError.value = 'Something went wrong!';
      debugPrint('Error fetching course journies $e');
    }

    fetchingJournies.value = false;
  }

  // fetchSummatives() async {
  //   isLoadingJournies.value = true;
  //   journies.clear();
  //   try {
  //     final response = await supabase
  //         .from('alt_proficiency_path_assignment')
  //         .select('dmod_sum_id,due_date,alt_mod_summatives(image,title)')
  //         .eq('active', 1)
  //         .eq('userid', homeController.userModel.userId!)
  //         .eq('a_cid', course.cid);
  //     for (var element in response) {
  //       Map map = await getStatus(
  //         element['dmod_sum_id'],
  //         DateTime.parse(element['due_date']),
  //       );
  //       Summative summative = Summative(
  //         status: map['status'],
  //         grade: (map['grade'] as num).toDouble(),
  //         dmodSumId: element['dmod_sum_id'],
  //         title: element['alt_mod_summatives']['title'],
  //         dueDate: DateTime.parse(element['due_date']),
  //         image: element['alt_mod_summatives']['image'],
  //       );
  //       journies.add(summative);
  //       print('summatives status ${summative.status}');
  //     }
  //   } catch (e) {
  //     print('Error gettting summatives $e');
  //   }
  //   isLoadingJournies.value = false;
  // }

  Future<Map<String, num>> getStatus(int dmodSumId, DateTime dueDate) async {
    final response = await supabase
        .from('summative_student_submissions')
        .select('status,grade')
        .eq('dmod_sum_id', dmodSumId)
        .eq('userid', homeController.userModel.userId!)
        .eq('a_cid', course.cid)
        .order('date', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response != null && response.isNotEmpty) {
      // Extract status and grade from response
      int status = response['status'] ?? 0;
      int grade = response['grade'] ?? 0;
      return {'status': status, 'grade': grade};
    } else {
      DateTime now = DateTime.now();
      if (now.isBefore(dueDate)) {
        return {
          'status': 3, // You can define 3 = No submission before due date
          'grade': -1,
        };
      } else {
        // Past due date → Overdue with no submission
        return {
          'status': 4, // You can define 4 = No submission after due date
          'grade': -1,
        };
      }
    }
  }
}
