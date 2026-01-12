import 'dart:math';

import 'package:get/get.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/learning_journey/controller/journey_controller.dart';
import 'package:lms_student/features/summative_assessment/models/lesson_tool.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LessonMaterielController extends GetxController {
  final supabase = Supabase.instance.client;
  final homeController = Get.find<HomeController>();

  RxBool loadingLessonTools = false.obs;
  RxList<LessonTool> lessonTools = <LessonTool>[].obs;

  RxBool loadingLessonMaterial = false.obs;
  RxList<LessonMaterial> lessonMaterials = <LessonMaterial>[].obs;

  RxBool loadingLessondMaterial = false.obs;
  RxList<LessonMaterial> lessondMaterials = <LessonMaterial>[].obs;

  RxBool loadingLessonddMaterial = false.obs;
  RxList<LessondMaterial> lessonddMaterials = <LessondMaterial>[].obs;
  final journeyController = Get.find<JourneyController>();

  fetchLessonTools(int lessonId) async {
    loadingLessonTools.value = true;
    lessonTools.clear();
    try {
      final response = await supabase
          .from('alt_mod_lesson_tools')
          .select('*,tool_student_access(tsaid)')
          .eq('dmod_lesson_id', lessonId)
          .eq('tool_student_access.userid', homeController.userModel.userId!)
          .eq('tool_student_access.dmod_lesson_id', lessonId);
      for (var element in response) {
        List? existList = element['tool_student_access'];
        //print('exist list $existList');
        lessonTools.add(
          LessonTool(
            dmodToolId: element['dmod_tool_id'],
            modnum: element['modnum'],
            dmodLessonId: element['dmod_lesson_id'],
            altToolId: element['alt_tool_id'],
            title: element['title'],
            description: element['description'],
            type: element['type'],
            link: element['link'],
            path: element['path'],
            text: element['text'],
            exist: existList != null && existList.isNotEmpty ? true : false,
          ),
        );
      }
    } catch (e) {
      print('Error fetching lesson tools $e');
    }
    loadingLessonTools.value = false;
  }

  writeLessonToolAccessed(int lessonId, int toolId) async {
    try {
      final existing = await supabase
          .from('tool_student_access')
          .select('tsaid')
          .eq('dmod_tool_id', toolId)
          .eq('dmod_lesson_id', lessonId)
          .eq('userid', homeController.userModel.userId!)
          .maybeSingle();
      if (existing != null) {
        print('Record already exists, skipping insert.');
        return;
      }
      await supabase.from('tool_student_access').insert([
        {
          'dmod_tool_id': toolId,
          'dmod_lesson_id': lessonId,
          'userid': homeController.userModel.userId!,
          'accessed': 1,
          'access_date': DateTime.now().toIso8601String(),
        },
      ]);
      print('Lesson tool access written successfully');
    } catch (e) {
      print('Error writing lesson tool access $e');
    }
  }

  //lesson materiel
  fetchLessonMateriel(int lessonId) async {
    loadingLessonMaterial.value = true;
    lessonMaterials.clear();
    try {
      final response = await supabase
          .from('alt_mod_lesson_material')
          .select('*,material_student_access(msaid)')
          .eq('dmod_lesson_id', lessonId)
          .eq(
            'material_student_access.userid',
            homeController.userModel.userId!,
          )
          .eq('material_student_access.dmod_lesson_id', lessonId);
      for (var element in response) {
        List? existList = element['material_student_access'];
        // print('material $element');
        lessonMaterials.add(
          LessonMaterial(
            dmodMatId: element['dmod_mat_id'],
            modnum: element['modnum'],
            dmodLessonId: element['dmod_lesson_id'],
            title: element['title'],
            description: element['description'],
            type: element['type'],
            link: element['link'],
            path: element['path'],
            text: element['text'],
            exist: existList != null && existList.isNotEmpty ? true : false,
          ),
        );
      }
    } catch (e) {
      print('Error fetching lesson material $e');
    }
    loadingLessonMaterial.value = false;
  }

  writeLessonMaterialAccessed(int lessonId, int matId) async {
    try {
      final existing = await supabase
          .from('material_student_access')
          .select('msaid')
          .eq('dmod_mat_id', matId)
          .eq('dmod_lesson_id', lessonId)
          .eq('userid', homeController.userModel.userId!)
          .maybeSingle();
      if (existing != null) {
        //print('Record already exists, skipping insert.');
        return;
      }
      await supabase.from('material_student_access').insert([
        {
          'dmod_mat_id': matId,
          'dmod_lesson_id': lessonId,
          'userid': homeController.userModel.userId!,
          'accessed': 1,
          'access_date': DateTime.now().toIso8601String(),
        },
      ]);
      journeyController.refreshLesson(lessonId);
      print('Lesson materiel access written successfully');
    } catch (e) {
      print('Error writing lesson materiel access $e');
    }
  }

  //lessond materiel
  fetchLessondMateriel(int lessonId) async {
    loadingLessondMaterial.value = true;
    lessondMaterials.clear();
    try {
      final response = await supabase
          .from('alt_mod_lesson_dmaterial')
          .select('*')
          .eq('dmod_lesson_id', lessonId);
      for (var element in response) {
        print('lesson d material $element');
        lessonddMaterials.add(
          LessondMaterial(
            dmodMatId: element['dmod_dmat_id'],
            modnum: element['modnum'],
            dmodLessonId: element['dmod_lesson_id'],
            title: element['title'],
            description: element['description'],
            type: element['type'],
            link: element['link'],
            path: element['path'],
            exist: false,
            text: element['text'],
          ),
        );
      }
    } catch (e) {
      print('Error fetching lesson material $e');
    }
    loadingLessondMaterial.value = false;
  }

  // writeLessondMaterialAccessed(int lessonId, int matId) async {
  //   try {
  //     final existing = await supabase
  //         .from('material_student_access')
  //         .select('msaid')
  //         .eq('dmod_mat_id', matId)
  //         .eq('dmod_lesson_id', lessonId)
  //         .eq('userid', homeController.userModel.userId!)
  //         .maybeSingle();
  //     if (existing != null) {
  //       //print('Record already exists, skipping insert.');
  //       return;
  //     }
  //     await supabase.from('material_student_access').insert([
  //       {
  //         'dmod_mat_id': matId,
  //         'dmod_lesson_id': lessonId,
  //         'userid': homeController.userModel.userId!,
  //         'accessed': 1,
  //         'access_date': DateTime.now().toIso8601String(),
  //       },
  //     ]);
  //     print('Lesson materiel access written successfully');
  //   } catch (e) {
  //     print('Error writing lesson materiel access $e');
  //   }
  // }
}
