// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ApprovedMaterial {
  final int acrid;
  final String title;
  final String description;
  String? instructions;
  final String path;
  final String type;
  ApprovedMaterial({
    required this.acrid,
    required this.title,
    required this.description,
    required this.path,
    required this.type,
    this.instructions,
  });

  Map<String, dynamic> toMap(int dumsumId) {
    return <String, dynamic>{
      'dmod_sum_id': dumsumId,
      'acrid': acrid,
      'path2': path,
      'instructions': instructions,
    };
  }

  factory ApprovedMaterial.fromMap(Map<String, dynamic> map) {
    return ApprovedMaterial(
      acrid: map['acrid'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      path: map['path'] as String,
      type: map['type'] as String,
    );
  }
  factory ApprovedMaterial.fromMapUpdate(Map<String, dynamic> map) {
    return ApprovedMaterial(
      acrid: map['acrid'] as int,
      title: map['academic_content_resources']['title'] as String,
      description: map['academic_content_resources']['description'] as String,
      instructions: map['instructions'] != null
          ? map['instructions'] as String
          : null,
      path: map['path2'] as String,
      type: map['academic_content_resources']['type'] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApprovedMaterial && other.acrid == acrid;
  }

  @override
  int get hashCode => acrid.hashCode;
}
