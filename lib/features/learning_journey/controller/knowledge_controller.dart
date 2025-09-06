import 'package:get/get.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/learning_journey/models/prior_knowledge.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KnowledgeController extends GetxController {
  final supabse = Supabase.instance.client;
  final homeController = Get.find<HomeController>();
  RxList<PriorKnowledge> priorKnowledges = <PriorKnowledge>[].obs;
  RxBool loadingKnowledges = false.obs;

  fetchPriorKnowledge(int dmodLessonId) async {
    loadingKnowledges.value = true;
    priorKnowledges.clear();
    try {
      final response = await supabse
          .from('alt_mod_lesson_pmaterial')
          .select('*,pmaterial_student_access(psaid)')
          .eq('dmod_lesson_id', dmodLessonId)
          .eq(
            'pmaterial_student_access.userid',
            homeController.userModel.userId!,
          )
          .eq('pmaterial_student_access.dmod_lesson_id', dmodLessonId);
      //print('prior knowledge id $dmodLessonId ${response.length}');
      for (var element in response) {
        List list = element['pmaterial_student_access'];
        priorKnowledges.add(
          PriorKnowledge(
            dmod_pmat_id: element['dmod_pmat_id'],
            title: element['title'],
            description: element['description'],
            exist: list.isNotEmpty,
            type: element['type'],
            link: element['link'],
            path: element['path'],
          ),
        );
      }
    } catch (e) {
      print('Error fetching prior knowledge $e');
    }
    loadingKnowledges.value = false;
  }

  writeAccessed(int lessonId, int pmatId) async {
    try {
      // 1. Check if record already exists
      final existing = await supabse
          .from('pmaterial_student_access')
          .select('psaid')
          .eq('dmod_pmat_id', pmatId)
          .eq('dmod_lesson_id', lessonId)
          .eq('userid', homeController.userModel.userId!)
          .maybeSingle();

      if (existing != null) {
        print('Record already exists, skipping insert.');
        return;
      }

      // 2. Insert if not found
      await supabse.from('pmaterial_student_access').insert([
        {
          'dmod_pmat_id': pmatId,
          'dmod_lesson_id': lessonId,
          'userid': homeController.userModel.userId!,
          'accessed': 1,
          'access_date': DateTime.now().toIso8601String(),
        },
      ]);

      print('Lesson access written successfully');
    } catch (e) {
      print('Error writing lesson access $e');
    }
  }
}
