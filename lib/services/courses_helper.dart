import 'dart:math';

import 'package:lms_student/features/home/models/course.dart';
import 'package:lms_student/features/home/services/grades_helper.dart';
import 'package:lms_student/features/home/services/proficiency_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoursesHelper {
  static SupabaseClient supabase = Supabase.instance.client;

  static Future<List<Course>> fetchStudentCourses({
    required int userId,
    required int learningYear,
    bool active = true,
  }) async {
    List<Course> courses = [];
    try {
      var query = supabase
          .from('student_course_assignment')
          .select(
            'alt_courses(a_cid,title1,image,course_type,active,users(last)),alt_learning_year(alyid,current),current_grade,incomplete,graduated,scaid,active',
          )
          .eq('userid', userId)
          .eq('learning_year', learningYear)
          //.or('graduated.is.null,graduated.neq.1')
          .eq('alt_courses.active', 1)
          .eq('alt_learning_year.current', 1);
      if (active) {
        query = query.eq('active', 1);
      }
      final response = await query
          .order('status', ascending: true)
          .order('scaid', ascending: false);
      if (response.isEmpty) {
        return [];
      }
      for (var row in response) {
        int acid = row['alt_courses']['a_cid'];
        Course course = Course(
          cid: acid,
          teacher: row['alt_courses']['users']['last'],
          title: row['alt_courses']['title1'],
          img: row['alt_courses']['image'],
          simpleGrade: (row['current_grade'] as num).toDouble(),
          grade: (row['current_grade'] as num).toDouble() != 7
              ? (row['current_grade'] as num).toDouble()
              : await GradeHelper.calculateGrade(acid, userId, supabase),
          graduated: (row['graduated']),
          incomplete: (row['incomplete']),
          courseType: row['alt_courses']['course_type'],
          active: row['alt_courses']['active'],
          scaid: row['scaid'],
          assignmentActive: row['active'],

          proficiency: await ProficiencyHelper.fetchProficiency(
            acid,
            userId,
            supabase,
          ),
        );
        courses.add(course);
        //course.getCourseLp();
      }
      return courses;
    } catch (e) {
      print('error $e');
    }
    return [];
  }

  static makeCourseInActive(int scaid, bool value) async {
    print('scaid $scaid');
    try {
      await supabase
          .from('student_course_assignment')
          .update({'active': value ? 1 : 2})
          .eq('scaid', scaid);
      print('course inactivated');
    } catch (e) {
      print('Error inactivating course $e');
    }
  }

  static String courseType(int type) {
    switch (type) {
      case 1:
        return '1st Semester';
      case 2:
        return '2nd Semester';
      case 3:
        return 'Summer Session';
      case 4:
        return 'Track A';
      case 5:
        return 'Track B';

      default:
        return '';
    }
  }

  static Future<Map<String, int>> getCourseLp({
    required int cid,
    required int couresType,
    required int currentLearningYear,
    required int schoolId,
    required int userId,
  }) async {
    Map<String, int> scores = {
      'formativeScore': 0,
      'summativeScore': 0,
      'kwlScore': 0,
      'total': 0,
    };
    try {
      int formativeScore = 0;
      int summativeScore = 0;
      int kwlScore = 0;

      final response = await supabase
          .from('alt_reporting_segment')
          .select('start,end')
          .eq('schoolid', schoolId)
          .eq('track', couresType)
          .eq('alyid', currentLearningYear)
          .maybeSingle();
      if (response != null) {
        final startDate = DateTime.parse(response['start']);
        final endDate = DateTime.parse(response['end']);

        final formativeSubmissions = await supabase
            .from('formative_student_submissions')
            .select('status')
            .eq('a_cid', cid)
            .eq('userid', userId)
            .neq('comment', 4)
            .inFilter('status', [1, 2])
            .gte('date', startDate.toIso8601String())
            .lte('date', endDate.toIso8601String());
        if (formativeSubmissions.isNotEmpty) {
          formativeScore = (formativeSubmissions.length * 25).clamp(0, 100);
          scores['formativeScore'] = formativeScore;
        }
        final summativeSubmissions = await supabase
            .from('summative_student_submissions')
            .select('status')
            .eq('a_cid', cid)
            .eq('userid', userId)
            .inFilter('status', [1, 2])
            .neq('comment', 4)
            .gte('date', startDate.toIso8601String())
            .lte('date', endDate.toIso8601String());
        if (summativeSubmissions.isNotEmpty) {
          summativeScore = 100;
          scores['summativeScore'] = summativeScore;
        }

        final kwlSubmissions = await supabase
            .from('kw_submissions')
            .select(
              'k_submitted,i_submitted,k_input,i_input,alt_mod_lessons(a_cid)',
            )
            //.eq('studentid', userId)
            .eq('alt_mod_lessons.a_cid', cid)
            .or(
              'k_submitted.not.is.null,k_submitted.gte.${startDate.toIso8601String()},k_submitted.lte.${endDate.toIso8601String()}',
            )
            .or(
              'i_submitted.not.is.null,i_submitted.gte.${startDate.toIso8601String()},i_submitted.lte.${endDate.toIso8601String()}',
            );
        if (kwlSubmissions.isNotEmpty) {
          kwlScore = (kwlSubmissions.length * 5).clamp(0, 10);
          scores['kwlScore'] = kwlScore;
        }
        // print('lp successfull ${formativeScore + summativeScore + kwlScore}');
        scores['total'] = (formativeScore + summativeScore + kwlScore).clamp(
          0,
          100,
        );
        return scores;
      } else {
        return scores;
      }
    } catch (e) {
      print('error driving lp $e');
    }
    return scores;
  }
}
