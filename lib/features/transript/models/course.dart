// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lms_student/features/transript/models/subject.dart';

class TranscriptCourse {
  final String name;
  final int credits;
  List<Subject> subjects;
  TranscriptCourse({required this.name, required this.credits, required this.subjects});
}
