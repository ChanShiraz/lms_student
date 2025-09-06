import 'package:get/get.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/learning_journey/models/lesson.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JourneyController extends GetxController {
  SupabaseClient supabase = Supabase.instance.client;
  final homeController = Get.find<HomeController>();
  RxList<Lesson> lessons = <Lesson>[].obs;
  RxBool isLoadingTitles = false.obs;

  getTitles(int dmodSumId) async {
    lessons.clear();
    isLoadingTitles.value = true;
    try {
      final response = await supabase
          .from('alt_mod_lessons')
          .select(
            'title,dmod_lesson_id,alt_proficiency_path_lessons(due_date),alt_mod_lesson_formatives(dmod_form_id,title,description)',
          )
          .eq('dmod_sum_id', dmodSumId)
          .eq(
            'alt_proficiency_path_lessons.userid',
            homeController.userModel.userId!,
          )
          .eq('alt_proficiency_path_lessons.dmod_sum_id', dmodSumId)
      //.order('alt_proficiency_path_lessons.due_date', ascending: true)
      ;
      if (response.isEmpty) {
        print('lessons are empty $dmodSumId');
      } else {
        for (var element in response) {
          final title = element['title'];
          final lessonId = element['dmod_lesson_id'];
          List<LessonFormative> formatives = [];
          for (var element in element['alt_mod_lesson_formatives']) {
            formatives.add(
              LessonFormative(
                formId: element['dmod_form_id'],
                title: element['title'],
                description: element['description'],
              ),
            );
          }
          lessons.add(
            Lesson(title: title, lessonId: lessonId, formatives: formatives),
          );
        }
      }
    } catch (e) {
      print('Error getting lessons id $dmodSumId $e');
    }
    isLoadingTitles.value = false;
  }
}
