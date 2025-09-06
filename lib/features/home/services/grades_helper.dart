import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GradeHelper {
  static Map<String, Color> gradeColors = {
    'INCOMPLETE': Colors.red,
    'PASS': Colors.grey,
    'EMERGING': Colors.orange,
    'CAPABLE': Colors.lightBlue,
    'BRIDGING': Colors.purple,
    'PROFICIENT': Colors.blue,
    'METACOGNITION': Colors.green,
    'IN PROGRESS': Colors.amber,
  };

  static String getGradeLabel(
    //String title,
    double grade,
    int graduated,
    int incomplete,
  ) {
    // print(
    //   'title $title grade $grade graduated $graduated incomplete $incomplete ',
    // );
    if (grade == 7) {
      return 'IN PROGRESS';
    }
    if (grade < 0.5) {
      return 'NO EVIDENCE';
    }
    if (grade == 0 && incomplete == 1) {
      return 'INCOMPLETE';
    }
    if (grade == 8 && graduated == 1 && incomplete == 0) {
      return 'PASS';
    }
    if (grade >= 0.5 && grade < 1.5 && graduated == 0 && incomplete == 1) {
      return 'EMERGING';
    }
    if (grade >= 1.5 && grade < 2.5 && graduated == 0 && incomplete == 1) {
      return 'CAPABLE';
    }
    if (grade >= 2.5 && grade < 3.5 && graduated == 1 && incomplete == 0) {
      return 'BRIDGING';
    }
    if (grade >= 3.5 && grade < 4.5 && graduated == 1 && incomplete == 0) {
      return 'PROFICIENT';
    }
    if (grade >= 4.5 && grade <= 5 && graduated == 1 && incomplete == 0) {
      return 'METACOGNITION';
    }

    return '';
  }

  static Color getGradeColor(String label) {
    return gradeColors[label] ?? Colors.grey;
  }

  static Future<double> calculateGrade(
    int acid,
    int userId,
    SupabaseClient supabase,
  ) async {
    final response = await supabase
        .from('summative_student_submissions')
        .select('subid,status,grade,weight,date')
        .eq('userid', userId)
        .eq('a_cid', acid);
    //print('response $response');
    if (response.isEmpty) {
      return 0;
    }
    if (response.length == 1) {
      return (response[0]['grade'] as num).toDouble();
    }
    if (response.length > 1) {
      return highestAverage(response);
    }
    // for (var element in response) {
    //   print('cid =$acid calculate grade ${element['status']}');
    // }
    return 0;
  }

  static double gradeSimpleAverage(PostgrestList grades) {
    double sum = 0;
    for (var grade in grades) {
      sum += (grade['grade'] as num).toDouble();
    }
    return sum / grades.length;
  }

  static double gradeWeightedAverage(PostgrestList grades) {
    double gradeSum = 0;
    double weightSum = 0;

    for (var grade in grades) {
      gradeSum += (grade['grade'] as num).toDouble();
      weightSum += (grade['weight'] as num).toDouble();
    }
    return gradeSum / weightSum;
  }

  static double gradeDecayingAverage(PostgrestList grades) {
    if (grades.isEmpty) return 0.0;
    grades.sort((a, b) {
      final dateA = DateTime.parse(a['date']);
      final dateB = DateTime.parse(b['date']);
      return dateB.compareTo(dateA);
    });

    double recent = (grades.first['grade'] as num).toDouble();
    double previousSum = 0.0;

    for (int i = 1; i < grades.length; i++) {
      previousSum += (grades[i]['grade'] as num).toDouble();
    }
    double previousAverage = previousSum / (grades.length - 1);

    double finalScore = (recent * 0.65) + (previousAverage * 0.35);
    return finalScore;
  }

  static double highestAverage(PostgrestList grades) {
    double simple = gradeSimpleAverage(grades);
    double weighted = gradeWeightedAverage(grades);
    double decaying = gradeDecayingAverage(grades);
    return [simple, weighted, decaying].reduce((a, b) => a > b ? a : b);
  }

  static SupabaseClient supabase = Supabase.instance.client;
  static Future<bool> hasValidSubmission({
    required int userId,
    required int aCid,
  }) async {
    try {
      // Step 1: Get all dmod_sum_ids from alt_proficiency_path for this user and course
      final dmodSumIdsResponse = await supabase
          .from('alt_proficiency_path_assignment')
          .select('dmod_sum_id')
          .eq('userid', userId)
          .eq('a_cid', aCid);

      final dmodSumIds = (dmodSumIdsResponse as List)
          .map((row) => row['dmod_sum_id'])
          .where((id) => id != null)
          .toList();

      if (dmodSumIds.isEmpty) {
        return false; // no assignments at all
      }

      // Step 2: Filter only active ones from alt_mod_summatives
      final activeSummativesResponse = await supabase
          .from('alt_mod_summatives')
          .select('dmod_sum_id')
          .inFilter('dmod_sum_id', dmodSumIds)
          .eq('active', 1);

      final activeDmodSumIds = (activeSummativesResponse as List)
          .map((row) => row['dmod_sum_id'])
          .toList();

      if (activeDmodSumIds.isEmpty) {
        return false; // no active summatives
      }

      final submissionResponse = await supabase
          .from('summative_student_submissions')
          .select('dmod_sum_id') // we just need to know if it exists
          .eq('userid', userId)
          .inFilter('dmod_sum_id', activeDmodSumIds)
          .limit(1); // no need to fetch all, just check if exists

      return (submissionResponse as List).isNotEmpty;
    } catch (e) {
      print('Error checking valid submission: $e');
      return false;
    }
  }

  static Future<int> countValidSummatives({
    //required SupabaseClient supabase,
    required int userId,
    required int aCid,
    required int schoolId,
    required int currentLearningYear,
    required int courseType,
  }) async {
    try {
      final segmentResponse = await supabase
          .from('alt_reporting_segment')
          .select('start, end')
          .eq('schoolid', schoolId)
          .eq('current', 1)
          .eq('alyid', currentLearningYear)
          .eq('track', courseType)
          .maybeSingle();
      print('grade alt_reporting_segment $segmentResponse');
      if (segmentResponse != null && segmentResponse.isNotEmpty) {
        final startDate = DateTime.parse(segmentResponse['start']);
        final endDate = DateTime.parse(segmentResponse['end']);

        final submissionsResponse = await supabase
            .from('summative_student_submissions')
            .select('dmod_sum_id, date, alt_courses(course_type, active)')
            .eq('userid', userId)
            .eq('a_cid', aCid)
            .eq('alt_courses.active', 1)
            .inFilter('status', [0, 1])
            .gte('date', startDate.toIso8601String())
            .lte('date', endDate.toIso8601String());

        for (var element in submissionsResponse) {
          final hasValidSubmission = await supabase
              .from('alt_mod_summatives')
              .select('dmod_sum_id')
              .eq('dmod_sum_id', element['dmod_sum_id']);
          if (hasValidSubmission.isEmpty) return 0;
          final submissions = hasValidSubmission as List;
          final uniqueIds = submissions
              .map((row) => row['dmod_sum_id'])
              .where((id) => id != null)
              .toSet();
          return uniqueIds.length;
        }
        // print('valid summative submissions $submissionsResponse');
      } else {
        print('grade alt_reporting_segment empty');
      }

      return 0;
    } catch (e) {
      print("Error counting valid submissions: $e");
      return 0;
    }
  }

  static Future<int> countAssignedSummatives({
    required SupabaseClient supabase,
    required int userId,
    required int aCid,
  }) async {
    try {
      final response = await supabase
          .from('alt_proficiency_path_assignment')
          .select('dmod_sum_id')
          .eq('userid', userId)
          .eq('a_cid', aCid);

      final rows = response as List;

      // Extract unique dmod_sum_id values
      final uniqueIds = rows
          .map((row) => row['dmod_sum_id'])
          .where((id) => id != null)
          .toSet();

      return uniqueIds.length;
    } catch (e) {
      print("Error counting assigned summatives: $e");
      return 0;
    }
  }

  static Future<num> calculateCompletionPercentage({
    required int userId,
    required int aCid,
    required int schoolId,
    required int currentLearningYear,
    required int couresType,
  }) async {
    final validCount = await countValidSummatives(
      userId: userId,
      aCid: aCid,
      schoolId: schoolId,
      currentLearningYear: currentLearningYear,
      courseType: couresType,
    );
    

    final assignedCount = await countAssignedSummatives(
      supabase: supabase,
      userId: userId,
      aCid: aCid,
    );
    if (assignedCount == 0) return 0;

    final percentage = (validCount / assignedCount) * 100;
    return percentage.round();
  }
}
