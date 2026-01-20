// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatCourseModel {
  final int acid;
  final String title;
  final int totalStudents;
  ChatCourseModel({
    required this.acid,
    required this.title,
    required this.totalStudents,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'acid': acid,
      'title': title,
      'totalStudents': totalStudents,
    };
  }

  factory ChatCourseModel.fromMap(Map<String, dynamic> map, int students) {
    return ChatCourseModel(
      acid: map['a_cid'] as int,
      title: map['title1'] as String,
      totalStudents: students,
    );
  }
}
