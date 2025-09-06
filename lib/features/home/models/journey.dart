// ignore_for_file: public_member_api_docs, sort_constructors_first
class Journey {
  int courseId;
  int dmodSumId;
  String courseTitle;
  String title;
  String? imageLink;
  DateTime dueDate;
  DateTime? completedDate;
  DateTime? assessedDate;
  String? assessedBy;
  int? status;
  double? grade;
  int track;
  Journey({
    required this.courseId,
    required this.dmodSumId,
    required this.title,
    required this.courseTitle,
    this.imageLink,
    required this.dueDate,
    this.completedDate,
    this.status,
    this.assessedDate,
    this.assessedBy,
    this.grade,
    required this.track,
  });
}
