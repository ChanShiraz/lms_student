import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:lms_student/features/courses/controllers/courses_controller.dart';
import 'package:lms_student/features/grades/controller/grades_controller.dart';
import 'package:lms_student/features/home/controller/home_controller.dart';
import 'package:lms_student/features/home/view/home_page.dart';
import 'package:lms_student/features/learning_journey/helpers/rubric_helper.dart';
import 'package:lms_student/features/learning_journey/models/summative_lesson.dart';
import 'package:lms_student/features/learning_journey/models/summative_submission.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SummativeAssessmentController extends GetxController {
  final RubricController rubricController = Get.put(RubricController());
  final homeController = Get.find<HomeController>();
  final supabase = Supabase.instance.client;
  RxBool submittingSummative = false.obs;
  final saLinkTextController = TextEditingController();
  final QuillController quillController = QuillController.basic();

  RxBool fetchingSummativeLesson = false.obs;
  Rx<SummativeLesson?> summativeLesson = Rx<SummativeLesson?>(null);

  RxBool fetchingSubSummative = false.obs;
  Rx<SummativeSubmission?> submittedSummative = Rx<SummativeSubmission?>(null);

  final coursesController = Get.find<CoursesController>();

  fetchSummativeLesson(int dmodSumId) async {
    fetchingSummativeLesson.value = true;
    try {
      final response = await supabase
          .from('alt_mod_summatives')
          .select('*,alt_courses(ccid)')
          .eq('dmod_sum_id', dmodSumId)
          .single();
      summativeLesson.value = SummativeLesson.fromJson(response);
      rubricController.getCompentencies(drlid: summativeLesson.value!.drlid);
      if (response['alt_courses']['ccid'] == 4) {
        rubricController.getScienceStandard(
          drlid: summativeLesson.value!.drlid,
        );
      } else {
        rubricController.getNonScienceStandard(
          drlid: summativeLesson.value!.drlid,
        );
      }

      rubricController.getRubric(
        drlid: summativeLesson.value!.drlid,
        dplvlid: 2,
      );
    } catch (e) {
      print('Error fetching summative lesson $e');
    }
    fetchingSummativeLesson.value = false;
  }

  fetchSubmittedSummative(int dmodSumId) async {
    fetchingSubSummative.value = true;
    try {
      final response = await supabase
          .from('summative_student_submissions')
          .select('*,users(first)')
          .eq('dmod_sum_id', dmodSumId)
          .eq('userid', homeController.userModel.userId!)
          .single();
      submittedSummative.value = SummativeSubmission.fromJson(response);
    } catch (e) {
      print('Error fetching formative $e');
    }
    fetchingSubSummative.value = false;
  }

  submitSummative(
    int dmodSumId,
    int courseTrack,
    int courseId,
    int type,
    final int? accessorId,
  ) async {
    submittingSummative.value = true;
    final userId = homeController.userModel.userId!;
    final now = DateTime.now().toIso8601String();
    final pathLink = saLinkTextController.text;
    try {
      // 1. Check if a current submission exists
      final existing = await supabase
          .from('summative_student_submissions')
          .select()
          .eq('userid', userId)
          .eq('dmod_sum_id', dmodSumId)
          .maybeSingle();
      // print('existing ${existing!['subid']}');
      if (existing != null) {
        final subid = existing['subid'];
        await copyDeleteSummativeDpcid(subid);
        await copyDeleteSummativePid(subid);
        await supabase.from('summative_student_submissions_past').insert({
          ...existing,
          'subid': subid,
        });

        await supabase
            .from('summative_student_submissions')
            .update({
              'dmod_sum_id': dmodSumId,
              'date': now,
              'type': type,
              'path_link': type == 2 ? pathLink : null,
              // 'assessed_by': 1,
              'status': 0,
              'grade': 0,
              'resubmit': 0,
              'comment': null,
              'assessed': null,
              'student_viewed': 0,
              'page': '0',
              'text': type == 4
                  ? jsonEncode(quillController.document.toDelta().toJson())
                  : null,
            })
            .eq('subid', subid);

        Get.offAll(HomePage());
        Future.delayed(Duration(milliseconds: 300), () {
          Get.rawSnackbar(message: 'Summative resubmitted successfully.');
        });
        homeController.updateJourney(dmodSumId: dmodSumId, aCid: courseId);
        //homeController.fetchJournies();
        homeController.fetchStudentCourses();
        coursesController.fetchCourses();
      } else {
        await supabase.from('summative_student_submissions').insert({
          'userid': homeController.userModel.userId,
          'a_cid': courseId,
          'learning_year': homeController.currentLearningYear,
          'track': courseTrack,
          'title': summativeLesson.value!.title,
          'description': summativeLesson.value!.task,
          'dmod_sum_id': dmodSumId,
          'date': now,
          'type': type,
          'path_link': pathLink,
          'assessed_by': accessorId,
          'status': 0,
          'weight': 1,
          'grade': 0,
          'resubmit': 0,
          'comment': null,
          'assessed': null,
          'student_viewed': 0,
          'page': '0',
          'text': type == 4
              ? jsonEncode(quillController.document.toDelta().toJson())
              : null,
        });
        // Get.back();
        // Get.back();
        // Get.back();
        Get.offAll(HomePage());
        Future.delayed(Duration(milliseconds: 300), () {
          Get.rawSnackbar(message: 'Summative submitted successfully.');
        });
        //homeController.fetchJournies();
         homeController.updateJourney(dmodSumId: dmodSumId, aCid: courseId);
        homeController.fetchStudentCourses();
        coursesController.fetchCourses();
      }
    } catch (e) {
      Get.rawSnackbar(message: 'Error submitting Summative, Please try again!');
      print('Error submitting Summative: $e');
    }

    submittingSummative.value = false;
  }

  Future<void> copyDeleteSummativeDpcid(int subid) async {
    try {
      final dpcidRows = await supabase
          .from('summative_dpcid')
          .select()
          .eq('subid', subid);
      if (dpcidRows.isEmpty) {
        print('No rows found in summative_dpcid for subid $subid');
        return;
      }
      final pastSubmission = await supabase
          .from('summative_student_submissions_past')
          .select('ssspid')
          .eq('subid', subid)
          .order('ssspid', ascending: false)
          .limit(1)
          .maybeSingle();

      if (pastSubmission == null) {
        print('No past summative record found for subid $subid');
        return;
      }
      final ssspid = pastSubmission['ssspid'];
      final rowsToInsert = dpcidRows.map((row) {
        row.remove('subid');
        return {...row, 'ssspid': ssspid};
      }).toList();
      await supabase.from('summative_dpcid_past').insert(rowsToInsert);
      await supabase.from('summative_dpcid').delete().eq('subid', subid);
      print('Copied and deleted summative_dpcid rows for subid $subid');
    } catch (e) {
      print('Error copying/deleting summative_dpcid: $e');
    }
  }

  copyDeleteSummativePid(int subid) async {
    try {
      final pidRows = await supabase
          .from('summative_pid')
          .select()
          .eq('subid', subid);

      if (pidRows.isEmpty) {
        print('No rows found in summative_pid for subid $subid');
        return;
      }
      final pastSubmission = await supabase
          .from('summative_student_submissions_past')
          .select('ssspid')
          .eq('subid', subid)
          .order('ssspid', ascending: false)
          .limit(1)
          .maybeSingle();

      if (pastSubmission == null) {
        print('No past summative record found for subid $subid');
        return;
      }
      final ssspid = pastSubmission['ssspid'];
      final rowsToInsert = pidRows.map((row) {
        final newRow = Map.of(row);
        newRow.remove('subid');
        newRow['ssspid'] = ssspid;
        return newRow;
      }).toList();
      await supabase.from('summative_pid_past').insert(rowsToInsert);
      await supabase.from('summative_pid').delete().eq('subid', subid);
      print('Copied and deleted summative_pid rows for subid $subid');
    } catch (e) {
      print('Error copying/deleting summative_pid: $e');
    }
  }
}
