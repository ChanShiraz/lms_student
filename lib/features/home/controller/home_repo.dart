import 'package:supabase_flutter/supabase_flutter.dart';

class HomeRepo {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getStatus({
    required int userId,
    required int dmodSumId,
    required int learningYear,
  }) async {
    final status = await supabase
        .from('summative_student_submissions')
        .select(
          'grade,status,date,assessed_by,assessed,'
          'users!summative_student_submissions_userid_fkey(last)',
        )
        .eq('userid', userId)
        .eq('learning_year', learningYear)
        .eq('dmod_sum_id', dmodSumId)
        .order('date', ascending: false)
        .limit(1)
        .maybeSingle();
    //print('dmod sum id $dmodSumId status ${status?['status']}');
    return status;
  }
}
