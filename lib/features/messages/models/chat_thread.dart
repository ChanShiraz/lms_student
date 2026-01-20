// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lms_student/features/messages/models/thread_types.dart';

class ChatThread {
  final String thread_id;
  final String kind;
  final List<dynamic> participants;
  final int? a_cid;
  final String? title;
  final int created_by;
  final DateTime created_at;
  final DateTime last_message_at;
  final String? last_message;
  int unreadCount;
  final String? courseTitle;
  final String? userName;
  ChatThread({
    required this.thread_id,
    required this.kind,
    required this.participants,
    this.a_cid,
    this.title,
    required this.created_by,
    required this.created_at,
    required this.last_message_at,
    this.last_message,
    required this.unreadCount,
    this.userName,
    this.courseTitle,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'thread_id': thread_id,
      'kind': kind,
      'participants': participants,
      'a_cid': a_cid,
      'title': title,
      'created_by': created_by,
      'created_at': created_at.millisecondsSinceEpoch,
      'last_message_at': last_message_at.millisecondsSinceEpoch,
    };
  }

  factory ChatThread.fromMap(
    Map<String, dynamic> map,
    int unreadCount,
    String? userName,
  ) {
    return ChatThread(
      thread_id: map['thread_id'] as String,
      kind: map['kind'] != null ? map['kind'] as String : '',
      participants: List<dynamic>.from((map['participants'])),
      //a_cid: map['a_cid'] != null ? map['a_cid'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
      created_by: map['created_by'] as int,
      created_at: DateTime.parse(map['created_at'] as String),
      last_message_at: DateTime.parse(map['last_message_at'] as String),
      last_message: map['last_message'] != null
          ? map['last_message'] as String
          : null,
      unreadCount: unreadCount,
      userName: userName,
      courseTitle: map['kind'] == ThreadType.course
          ? map['course_title'] != null
                ? map['course_title'] as String
                : null
          : null,
    );
  }
}
