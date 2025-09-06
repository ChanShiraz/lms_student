import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  RxBool isLoadingCourses = false.obs;
  RxBool isLoadingJourneys = true.obs;
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

  Future<void> fetchStudentCourses() async {
    courses.clear();
    isLoadingCourses.value = true;
    courses.value = await CoursesHelper.fetchStudentCourses(
      userId: userModel.userId!,
      learningYear: currentLearningYear,
    );

    isLoadingCourses.value = false;
  }

  fetchJournies() async {
    isLoadingJourneys.value = true;
    journies.clear();
    try {
      final courseIds = await supabase
          .from('alt_proficiency_path_assignment')
          .select(
            'a_cid, dmod_sum_id, due_date, completed_date,alt_mod_summatives(image,title), alt_courses(title1,course_type) ',
          )
          .eq('userid', userModel.userId!)
          .eq('alt_courses.active', 1)
          .eq('alt_courses.alyid', currentLearningYear)
          .eq('active', 1)
          .order('due_date', ascending: true);
      for (var element in courseIds) {
        if (element['alt_courses'] != null) {
          final status = await supabase
              .from('summative_student_submissions')
              .select('grade,status,date,assessed_by,assessed,users(last)')
              .eq('userid', userModel.userId!)
              .eq('learning_year', currentLearningYear)
              .eq('dmod_sum_id', element['dmod_sum_id'])
              .order('date', ascending: false)
              .limit(1)
              .maybeSingle();
          final dueDate = DateTime.parse(element['due_date']);
          int? finalStatus;
          if (status != null && status['status'] != null) {
            finalStatus = status['status'];
          } else {
            if (dueDate.isBefore(DateTime.now())) {
              finalStatus = 3;
            } else {
              finalStatus = null;
            }
          }
          Journey journey = Journey(
            courseId: element['a_cid'],
            status: finalStatus,
            dmodSumId: element['dmod_sum_id'],
            courseTitle: element['alt_courses']['title1'],
            imageLink: element['alt_mod_summatives']['image'],
            title: element['alt_mod_summatives']['title'],
            dueDate: DateTime.parse(element['due_date']),
            assessedDate: status?['assessed'] != null
                ? DateTime.parse(status!['assessed'])
                : null,
            assessedBy: status?['assessed_by'] != null
                ? status!['users']['last']
                : null,
            grade: (status?['grade'] as num?)?.toDouble(),
            track: element['alt_courses']['course_type'],
          );
          print('journey grade ${journey.grade}');
          journies.add(journey);
        }
      }
    } catch (e) {
      print('Error jorneyes $e');
    }
    // journies.value = journies.reversed.toList();
    isLoadingJourneys.value = false;
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
