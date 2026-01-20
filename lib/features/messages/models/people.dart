// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class People {
  final int userId;
  final String name;
  People({required this.userId, required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'userId': userId, 'name': name};
  }

  factory People.fromMap(Map<String, dynamic> map) {
    return People(
      userId: map['userid'] as int,
      name: '${map['first']} ${map['last']}',
    );
  }
}
