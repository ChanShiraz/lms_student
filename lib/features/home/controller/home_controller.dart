import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms_student/features/home/controller/home_repo.dart';
import 'package:lms_student/features/home/models/course.dart';
import 'package:lms_student/features/home/models/journey.dart';
import 'package:lms_student/services/courses_helper.dart';
import 'package:lms_student/features/home/services/grades_helper.dart';
import 'package:lms_student/features/home/models/proficiency.dart';
import 'package:lms_student/features/home/services/proficiency_helper.dart';
import 'package:lms_student/features/profile/model/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  SupabaseClient supabase = Supabase.instance.client;
  final homeRepo = HomeRepo();
  RxBool fetchingCourses = false.obs;
  final coursesHelper = CoursesHelper();

  RxList<Course> courses = <Course>[].obs;
  RxList<Journey> journies = <Journey>[].obs;
  late UserModel userModel;
  final box = GetStorage();
  RxInt lpWork = 0.obs;
  int currentLearningYear = 13;

  @override
  void onInit() {
    userModel = UserModel.fromJson(box.read('user'));
    //print(await learningYear());
    fetchStudentCourses();
    fetchJournies();

    super.onInit();
  }

  Future<int> learningYear() async {
    final response = await supabase
        .from('alt_learning_year')
        .select('alyid')
        .eq('current', 1)
        .maybeSingle();
    return response!['alyid'];
  }

  RxString fetchingCoursesError = ''.obs;
  Future<void> fetchStudentCourses() async {
    try {
      courses.clear();
      fetchingCourses.value = true;
      fetchingCoursesError.value = '';
      courses.value = await CoursesHelper.fetchStudentCourses(
        userId: userModel.userId!,
        learningYear: currentLearningYear,
      );
    } catch (e) {
      fetchingCoursesError.value = 'Something went wrong';
      debugPrint('error loading courses $e');
    }
    fetchingCourses.value = false;
  }

  RxBool fetchingJournies = true.obs;
  RxString fetchingJourniesError = ''.obs;

  fetchJournies() async {
    fetchingJournies.value = true;
    fetchingJourniesError.value = '';
    journies.clear();
    try {
      final response = await supabase
          .from('alt_proficiency_path_assignment')
          .select(
            'a_cid, dmod_sum_id, due_date, completed_date,'
            'alt_mod_summatives(image,title),'
            'alt_courses(title1,course_type)',
          )
          .eq('userid', userModel.userId!)
          .eq('alt_courses.active', 1)
          .eq('alt_courses.alyid', currentLearningYear)
          .eq('active', 1)
          .order('due_date', ascending: true);

      for (final element in response) {
        if (element['alt_courses'] == null) continue;

        final status = await homeRepo.getStatus(
          userId: userModel.userId!,
          learningYear: currentLearningYear,
          dmodSumId: element['dmod_sum_id'],
        );
        // await supabase
        //     .from('summative_student_submissions')
        //     .select(
        //       'grade,status,date,assessed_by,assessed,'
        //       'users!summative_student_submissions_userid_fkey(last)',
        //     )
        //     .eq('userid', userModel.userId!)
        //     .eq('learning_year', currentLearningYear)
        //     .eq('dmod_sum_id', element['dmod_sum_id'])
        //     .order('date', ascending: false)
        //     .limit(1)
        //     .maybeSingle();

        final journey = Journey.fromMap(
          element: element,
          status: status,
          now: DateTime.now(),
        );

        journies.add(journey);
      }
    } catch (e) {
      fetchingJourniesError.value = 'Something went wrong!';
      debugPrint('Error journeys $e');
    }
    fetchingJournies.value = false;
  }

  Future<void> updateJourney({
    required int dmodSumId,
    required int aCid,
  }) async {
    try {
      final element = await supabase
          .from('alt_proficiency_path_assignment')
          .select(
            'a_cid, dmod_sum_id, due_date, completed_date,'
            'alt_mod_summatives(image,title),'
            'alt_courses(title1,course_type)',
          )
          .eq('userid', userModel.userId!)
          .eq('a_cid', aCid)
          .eq('dmod_sum_id', dmodSumId)
          .eq('alt_courses.active', 1)
          .eq('alt_courses.alyid', currentLearningYear)
          .eq('active', 1)
          .maybeSingle();
      if (element == null || element['alt_courses'] == null) return;
      final status = await homeRepo.getStatus(
        userId: userModel.userId!,
        dmodSumId: dmodSumId,
        learningYear: currentLearningYear,
      );
      final updatedJourney = Journey.fromMap(
        element: element,
        status: status,
        now: DateTime.now(),
      );

      final index = journies.indexWhere(
        (j) => j.dmodSumId == dmodSumId && j.courseId == aCid,
      );

      if (index != -1) {
        journies[index] = updatedJourney;
        journies.refresh();
      } else {
        journies.add(updatedJourney);
      }
    } catch (e) {
      debugPrint('Error updating journey $e');
    }
  }

  Future<double> calculateLp() async {
    double totalCourseLp = 0;
    int courseCount = courses.length;
    num totalKwlSubmissions = 0;
    for (var element in courses) {
      Map lpMap = await element.getCourseLp();
      totalCourseLp += lpMap['total'] ?? 0;
      totalKwlSubmissions += lpMap['kwlScore'] ?? 0;
    }
    double averageCourseLp = courseCount > 0 ? totalCourseLp / courseCount : 0;
    double kwlBonus = (totalKwlSubmissions * 5).clamp(0, 10).toDouble();
    double finalLp = averageCourseLp + kwlBonus;
    print('total lp $finalLp');

    return finalLp;
  }
}
