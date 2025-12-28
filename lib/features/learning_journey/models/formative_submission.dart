class FormativeSubmission {
  final int fsubid;
  final int dmodFormId;
  final int userid;
  final int assessedBy;
  final String title;
  final String description;
  final DateTime date;
  final DateTime? assessed;
  final int status;
  final int type;
  final String pathLink;
  final String page;
  final int dmodLessonId;
  final int aCid;
  final int learningYear;
  final int track;
  final int resubStatus;
  final int studentViewed;
  final int assessed_by;
  String? text;
  String? comment;
  String? assessBy;

  FormativeSubmission({
    required this.fsubid,
    required this.dmodFormId,
    required this.userid,
    required this.assessedBy,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.type,
    required this.pathLink,
    required this.page,
    required this.dmodLessonId,
    required this.aCid,
    required this.learningYear,
    required this.track,
    required this.resubStatus,
    required this.studentViewed,
    required this.assessed_by,
    this.assessed,
    this.text,
    this.comment,
    this.assessBy
  });

  /// Convert Supabase row -> Dart object
  factory FormativeSubmission.fromMap(Map<String, dynamic> map) {
    return FormativeSubmission(
      fsubid: map['fsubid'] as int,
      dmodFormId: map['dmod_form_id'] as int,
      assessed_by: map['assessed_by'] as int,
      userid: map['userid'] as int,
      assessedBy: map['assessed_by'] as int,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.parse(map['date']),
      assessed: map['assessed'] != null
          ? DateTime.parse(map['assessed'])
          : null,
      status: map['status'] as int,
      type: map['type'] as int,
      pathLink: map['path_link'] ?? '',
      page: map['page'] ?? '0',
      dmodLessonId: map['dmod_lesson_id'] as int,
      aCid: map['a_cid'] as int,
      learningYear: map['learning_year'] as int,
      track: map['track'] as int,
      resubStatus: map['resub_status'] as int,
      text: map['text'] ?? '',
      studentViewed: map['student_viewed'] as int,
      comment: map['comment'] ?? null,
      assessBy: map['users']['first'] ?? null,
    );
  }

  /// Convert Dart object -> Map for insert/update
  Map<String, dynamic> toMap() {
    return {
      'fsubid': fsubid,
      'dmod_form_id': dmodFormId,
      'userid': userid,
      'assessed_by': assessedBy,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'status': status,
      'type': type,
      'path_link': pathLink,
      'page': page,
      'dmod_lesson_id': dmodLessonId,
      'a_cid': aCid,
      'learning_year': learningYear,
      'track': track,
      'resub_status': resubStatus,
      'student_viewed': studentViewed,
    };
  }
}
