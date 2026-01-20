// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MessageModel {
  final String id;
  final String text;
  final int senderId;
  MessageModel({required this.id, required this.text, required this.senderId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'text': text};
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['msg_id'] as String,
      text: map['body'] as String,
      senderId: map['sender_userid'] as int,
    );
  }
}
