import 'package:lms_student/features/home/models/proficiency.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProficiencyHelper {
  static SupabaseClient supabase = Supabase.instance.client;
  static Future<Proficiency> fetchProficiency(
    int courseId,
    int userId,
    SupabaseClient supabase,
  ) async {
    Proficiency proficiency = Proficiency(
      completed: 0,
      resubmit: 0,
      notCompleted: 0,
      pastDue: 0,
    );

    try {
      // Get assignments
      final assigned = await supabase
          .from('alt_proficiency_path_assignment')
          .select('dmod_sum_id, completed_date, due_date')
          .eq('userid', userId)
          .eq('a_cid', courseId);

      if (assigned.isEmpty) {
        return proficiency; // No assignments at all
      }

      // Extract assignment IDs
      final ids = assigned
          .map((row) => row['dmod_sum_id'])
          .whereType<int>()
          .toList();
      // print('ids: $ids');

      if (ids.isEmpty) {
        return proficiency; // No valid IDs found
      }

      // Get submissions against these IDs
      final submissions = await supabase
          .from('summative_student_submissions')
          .select('dmod_sum_id, status, grade')
          .eq('userid', userId)
          .inFilter('dmod_sum_id', ids);

      // Count completed and resubmit
      if (submissions.isNotEmpty) {
        int completedCount = submissions.where((e) => e['status'] == 1).length;
        int resubmitCount = submissions.where((e) => e['status'] == 2).length;

        proficiency.completed = completedCount;
        proficiency.resubmit = resubmitCount;

        // Determine which IDs have no submissions
        final submittedIds = submissions
            .map((row) => row['dmod_sum_id'])
            .whereType<int>()
            .toList();
        final missingIds = ids
            .where((id) => !submittedIds.contains(id))
            .toList();

        // Handle "missing" IDs → either not completed or past due
        if (missingIds.isNotEmpty) {
          final now = DateTime.now();
          for (var row in assigned.where(
            (r) => missingIds.contains(r['dmod_sum_id']),
          )) {
            final completedDateStr = row['completed_date'];
            final dueDateStr = row['due_date'];
            DateTime? dueDate = dueDateStr != null
                ? DateTime.tryParse(dueDateStr)
                : null;

            if (completedDateStr == null ||
                completedDateStr.toString().isEmpty) {
              if (dueDate != null && dueDate.isBefore(now)) {
                proficiency.pastDue += 1;
              } else {
                proficiency.notCompleted += 1;
              }
            }
          }
        }
      } else {
        // If no submissions at all, handle all as not completed or past due
        final now = DateTime.now();
        for (var row in assigned) {
          final completedDateStr = row['completed_date'];
          final dueDateStr = row['due_date'];
          DateTime? dueDate = dueDateStr != null
              ? DateTime.tryParse(dueDateStr)
              : null;

          if (completedDateStr == null || completedDateStr.toString().isEmpty) {
            if (dueDate != null && dueDate.isBefore(now)) {
              proficiency.pastDue += 1;
            } else {
              proficiency.notCompleted += 1;
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching proficiency: $e');
    }
    return proficiency;
  }

  static Future<bool> checkSubmission(
    int courseId,
    int userId,
  ) async {
    try {
      // Get assignments
      final assigned = await supabase
          .from('alt_proficiency_path_assignment')
          .select('dmod_sum_id,')
          .eq('userid', userId)
          .eq('active', 1)
          .eq('a_cid', courseId);

      if (assigned.isEmpty) {
        return false;
      }

      // Extract assignment IDs
      final ids = assigned
          .map((row) => row['dmod_sum_id'])
          .whereType<int>()
          .toList();

      if (ids.isEmpty) {
        return false;
      }

      final submissions = await supabase
          .from('summative_student_submissions')
          .select('dmod_sum_id, status, grade')
          .eq('userid', userId)
          .inFilter('dmod_sum_id', ids);

      if (submissions.isNotEmpty) {
        return true;
      }
    } catch (e) {
      print('Error fetching proficiency: $e');
    }
    return false;
  }
}

// import 'package:lms_student/features/home/models/proficiency.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ProficiencyHelper {
//   static Future<Proficiency> fetchProficiency(
//     int courseId,
//     int userId,
//     SupabaseClient supabase,
//   ) async {
//     Proficiency proficiency = Proficiency(
//       completed: 0,
//       resubmit: 0,
//       notCompleted: 0,
//       pastDue: 0,
//     );

//     try {
//       // Get assignments
//       final assigned = await supabase
//           .from('alt_proficiency_path_assignment')
//           .select('dmod_sum_id, completed_date, due_date')
//           .eq('userid', userId)
//           .eq('a_cid', courseId);

//       if (assigned.isEmpty) {
//         // print('No assignments found for course $courseTitle');
//         return proficiency;
//       }

//       final ids = assigned
//           .map((row) => row['dmod_sum_id'])
//           .whereType<int>()
//           .toList();
//       print('ids $ids');

//       // Get submissions
//       final submissions = await supabase
//           .from('summative_student_submissions')
//           .select('dmod_sum_id, status, grade')
//           .eq('userid', userId)
//           .inFilter('dmod_sum_id', ids);
//       if (submissions.isNotEmpty) {
//         int completedCount = submissions.where((e) => e['status'] == 1).length;
//         int resubmitCount = submissions.where((e) => e['status'] == 2).length;

//         proficiency.completed = completedCount;
//         proficiency.resubmit = resubmitCount;
//       } else {
//         final now = DateTime.now();
//         for (var row in assigned) {
//           final completedDateStr = row['completed_date'];
//           final dueDateStr = row['due_date'];
//           DateTime? dueDate = dueDateStr != null
//               ? DateTime.tryParse(dueDateStr)
//               : null;

//           // Only consider assignments with no completed_date
//           if (completedDateStr == null || completedDateStr.toString().isEmpty) {
//             if (dueDate != null && dueDate.isBefore(now)) {
//               // Due date already passed → past due
//               proficiency.pastDue += 1;
//             } else {
//               // Due date is in the future → not completed yet
//               proficiency.notCompleted += 1;
//             }
//           }
//         }
//       }
//     } catch (e) {
//       print('Error fetching journey for $e');
//     }
//     return proficiency;
//   }
// }
