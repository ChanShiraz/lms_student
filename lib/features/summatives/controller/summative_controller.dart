import 'package:get/get.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/home/models/course.dart';
import 'package:lms_student/features/summatives/model/summative.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SummativeController extends GetxController {
  SupabaseClient supabase = Supabase.instance.client;

  final Course course;
  final HomeController homeController = Get.find<HomeController>();

  SummativeController({required this.course});
  RxBool isLoadingSummative = false.obs;
  RxList<Summative> summatives = <Summative>[].obs;

  fetchSummatives() async {
    isLoadingSummative.value = true;
    summatives.clear();
    try {
      final response = await supabase
          .from('alt_proficiency_path_assignment')
          .select('dmod_sum_id,due_date,alt_mod_summatives(image,title)')
          .eq('active', 1)
          .eq('userid', homeController.userModel.userId!)
          .eq('a_cid', course.cid);
      for (var element in response) {
        Map map = await getStatus(
          element['dmod_sum_id'],
          DateTime.parse(element['due_date']),
        );
        Summative summative = Summative(
          status: map['status'],
           grade: (map['grade'] as num).toDouble(),
          dmodSumId: element['dmod_sum_id'],
          title: element['alt_mod_summatives']['title'],
          dueDate: DateTime.parse(element['due_date']),
          image: element['alt_mod_summatives']['image'],
        );
        summatives.add(summative);
        print('summatives status ${summative.status}');
      }
    } catch (e) {
      print('Error gettting summatives $e');
    }
    isLoadingSummative.value = false;
  }

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
