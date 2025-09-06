// ignore_for_file: public_member_api_docs, sort_constructors_first
class Summative {
  final int dmodSumId;
  final String title;
  final String? image;
  DateTime dueDate;
  final int status;
  double grade;
  Summative({
    required this.dmodSumId,
    required this.title,
    this.image,
    required this.dueDate,
    required this.status,
    required this.grade
  });
}
