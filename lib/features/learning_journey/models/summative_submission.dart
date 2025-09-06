import 'dart:convert';

class SummativeSubmission {
  final int subid;
  final int dmodFormId;
  final int userId;
  final int assessedBy;
  final String title;
  final String description;
  final DateTime date;
  final DateTime? assessed;
  final int status;
  final int type;
  final String pathLink;
  final String page;
  //final int dmodLessonId;
  final int aCid;
  final int learningYear;
  final int track;
  final int resubStatus;
  final int studentViewed;
  final String? text;
  final String? comment;
  final String? assessBy;

  SummativeSubmission({
    required this.subid,
    required this.dmodFormId,
    required this.userId,
    required this.assessedBy,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.type,
    required this.pathLink,
    required this.page,
    //required this.dmodLessonId,
    required this.aCid,
    required this.learningYear,
    required this.track,
    required this.resubStatus,
    required this.studentViewed,
    this.assessed,
    this.text,
    this.comment,
    this.assessBy,
  });

  factory SummativeSubmission.fromJson(Map<String, dynamic> json) {
    return SummativeSubmission(
      subid: json['subid'],
      dmodFormId: json['dmod_sum_id'],
      userId: json['userid'],
      assessedBy: json['assessed_by'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      assessed: json['assessed'] != null
          ? DateTime.parse(json['assessed'])
          : null,
      status: json['status'],
      type: json['type'],
      pathLink: json['path_link'] ?? '',
      page: json['page'] ?? '0',
      //dmodLessonId: json['dmod_lesson_id'],
      aCid: json['a_cid'],
      learningYear: json['learning_year'],
      track: json['track'],
      resubStatus: json['resubmit'],
      studentViewed: json['student_viewed'],
      text: json['text'],
      comment: json['comment'],
      assessBy: json['users']['first'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ssspid': subid,
      'dmod_form_id': dmodFormId,
      'userid': userId,
      'assessed_by': assessedBy,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'status': status,
      'type': type,
      'path_link': pathLink,
      'page': page,
      //'dmod_lesson_id': dmodLessonId,
      'a_cid': aCid,
      'learning_year': learningYear,
      'track': track,
      'resub_status': resubStatus,
      'student_viewed': studentViewed,
      'text': text,
    };
  }
}
