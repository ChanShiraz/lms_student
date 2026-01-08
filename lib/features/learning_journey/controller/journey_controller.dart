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
            'title,dmod_lesson_id,alt_proficiency_path_lessons(due_date),alt_mod_lesson_formatives(dmod_form_id,title,description),pmaterial_student_access(accessed),tool_student_access(accessed),material_student_access(accessed)',
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
                status: await checkFormativeStatus(element['dmod_form_id']),
              ),
            );
          }
          final bool pMaterialAccessed = _allAccessed(
            element['pmaterial_student_access'],
          );
          final bool lMaterialAccessed =
              _allAccessed(element['tool_student_access']) &&
              _allAccessed(element['material_student_access']);
          lessons.add(
            Lesson(
              title: title,
              dmod_lesson_id: lessonId,
              formatives: formatives,
              pMaterialAccessed: pMaterialAccessed,
              lMaterialAccessed: lMaterialAccessed,
              formativeStatus: calculateLessonFormativeStatus(formatives),
            ),
          );
        }
      }
    } catch (e) {
      print('Error getting lessons id $dmodSumId $e');
    }
    isLoadingTitles.value = false;
  }

  bool _allAccessed(List? list) {
    return list != null &&
        list.isNotEmpty &&
        list.every((e) => e['accessed'] == 1);
  }

  Future<int> checkFormativeStatus(int dmodFormId) async {
    final submission = await supabase
        .from('formative_student_submissions')
        .select('status')
        .eq('dmod_form_id', dmodFormId)
        .eq('userid', homeController.userModel.userId!)
        .maybeSingle();

    if (submission == null) {
      return -1;
    }
    return submission['status'];
  }

  Future<void> refreshLesson(int dmodLessonId) async {
    try {
      final updatedLesson = await _fetchSingleLesson(dmodLessonId);
      if (updatedLesson == null) return;
      final index = lessons.indexWhere((l) => l.dmod_lesson_id == dmodLessonId);
      if (index != -1) {
        lessons[index] = updatedLesson;
      }
    } catch (e) {
      print('Error refreshing lesson $dmodLessonId: $e');
    }
  }

  Future<Lesson?> _fetchSingleLesson(int dmodLessonId) async {
    final response = await supabase
        .from('alt_mod_lessons')
        .select('''
        title,
        dmod_lesson_id,
        alt_mod_lesson_formatives(dmod_form_id,title,description),
        pmaterial_student_access(accessed),
        tool_student_access(accessed),
        material_student_access(accessed)
        ''')
        .eq('dmod_lesson_id', dmodLessonId)
        .maybeSingle();

    if (response == null) return null;

    /// 🔹 Formatives
    List<LessonFormative> formatives = [];
    for (var f in response['alt_mod_lesson_formatives'] ?? []) {
      formatives.add(
        LessonFormative(
          formId: f['dmod_form_id'],
          title: f['title'],
          description: f['description'],
          status: await checkFormativeStatus(f['dmod_form_id']),
        ),
      );
    }

    return Lesson(
      title: response['title'],
      dmod_lesson_id: response['dmod_lesson_id'],
      formatives: formatives,
      pMaterialAccessed: _allAccessed(response['pmaterial_student_access']),
      lMaterialAccessed:
          _allAccessed(response['tool_student_access']) &&
          _allAccessed(response['material_student_access']),
      formativeStatus: calculateLessonFormativeStatus(formatives),
    );
  }

  int calculateLessonFormativeStatus(List<LessonFormative> formatives) {
    if (formatives.isEmpty) {
      return FormativeStatus.notSubmitted;
    }
    if (formatives.every((f) => f.status == FormativeStatus.notSubmitted)) {
      return FormativeStatus.notSubmitted;
    }
    if (formatives.any((f) => f.status == FormativeStatus.rejected)) {
      return FormativeStatus.rejected;
    }
    if (formatives.any((f) => f.status == FormativeStatus.submitted)) {
      return FormativeStatus.submitted;
    }
    if (formatives.every((f) => f.status == FormativeStatus.approved)) {
      return FormativeStatus.approved;
    }
    return FormativeStatus.submitted;
  }
}

class FormativeStatus {
  static const int notSubmitted = -1;
  static const int submitted = 0;
  static const int approved = 1;
  static const int rejected = 2;
}
