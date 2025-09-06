import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/learning_journey/models/formative_submission.dart';
import 'package:lms_student/features/learning_journey/models/lesson.dart';
import 'package:lms_student/features/learning_journey/view/formative/formative_assessment_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FormativeAssessmentController extends GetxController {
  final homeController = Get.find<HomeController>();
  final supabase = Supabase.instance.client;
  RxBool submittingFormative = false.obs;
  final faLinkTextController = TextEditingController();
  final QuillController quillController = QuillController.basic();

  RxBool fetchingFormative = false.obs;
  Rx<FormativeSubmission?> formative = Rx<FormativeSubmission?>(null);

  fetchFormative(int formId) async {
    fetchingFormative.value = true;
    try {
      final response = await supabase
          .from('formative_student_submissions')
          .select('*,users(first)')
          .eq('dmod_form_id', formId)
          .eq('userid', homeController.userModel.userId!)
          .single();
      formative.value = FormativeSubmission.fromMap(response);
    } catch (e) {
      print('Error fetching formative $e');
    }
    fetchingFormative.value = false;
  }

  submitFormative(
    int courseTrack,
    int courseId,
    int lessonId,
    int type,
    LessonFormative formative,
  ) async {
    submittingFormative.value = true;
    final userId = homeController.userModel.userId!;
    final now = DateTime.now().toIso8601String();
    final pathLink = faLinkTextController.text;
    try {
      // 1. Check if a current submission exists
      final existing = await supabase
          .from('formative_student_submissions')
          .select()
          .eq('userid', userId)
          .eq('dmod_form_id', formative.formId)
          .maybeSingle();

      if (existing == null) {
        await supabase.from('formative_student_submissions').insert({
          'dmod_form_id': formative.formId,
          'userid': userId,
          'assessed_by': 1,
          'title': formative.title,
          'description': formative.description,
          'date': now,
          'status': 0,
          'type': type,
          'path_link': pathLink,
          'page': '0',
          'dmod_lesson_id': lessonId,
          'a_cid': courseId,
          'learning_year': homeController.currentLearningYear,
          'track': courseTrack,
          'resub_status': 0,
          'student_viewed': 0,
          'text': type == 4
              ? jsonEncode(quillController.document.toDelta().toJson())
              : null,
        });
        //print('Formative submitted successfully (first submission).');
        Get.back();
        Get.back();
        Future.delayed(Duration(milliseconds: 300), () {
          Get.rawSnackbar(message: 'Formative submitted successfully.');
        });
      } else {
        final fsubid = existing['fsubid'];
        // print('fsubid $fsubid');

        // Copy existing to past table
        await supabase.from('formative_student_submissions_past').insert({
          ...existing,
          'fsubid': fsubid,
        });

        // Update existing row with new data and reset assessment fields
        await supabase
            .from('formative_student_submissions')
            .update({
              'date': now,
              'type': type,
              'path_link': pathLink,
              'assessed_by': 1,
              'status': 0,
              'comment': null,
              'assessed': null,
              'resub_status': 0,
              'student_viewed': 0,
              'page': '0',
              'text': jsonEncode(quillController.document.toDelta().toJson()),
            })
            .eq('fsubid', fsubid);
        Get.back();
        Get.back();
        Future.delayed(Duration(milliseconds: 300), () {
          Get.rawSnackbar(message: 'Formative resubmitted successfully.');
        });
      }
    } catch (e) {
      Get.rawSnackbar(message: 'Error submitting formative, Please try again!');
      print('Error submitting formative: $e');
    }

    submittingFormative.value = false;
  }
}
