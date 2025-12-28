class Journey {
  int courseId;
  int dmodSumId;
  final int? accessorId;
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
    required this.accessorId,
    this.imageLink,
    required this.dueDate,
    this.completedDate,
    this.status,
    this.assessedDate,
    this.assessedBy,
    this.grade,
    required this.track,
  });

  /// ✅ Factory constructor
  factory Journey.fromMap({
    required Map<String, dynamic> element,
    required Map<String, dynamic>? status,
    required DateTime now,
  }) {
    final dueDate = DateTime.parse(element['due_date']);

    int? finalStatus;
    if (status != null && status['status'] != null) {
      finalStatus = status['status'];
    } else if (dueDate.isBefore(now)) {
      finalStatus = 3; // overdue
    }

    return Journey(
      courseId: element['a_cid'],
      dmodSumId: element['dmod_sum_id'],
      courseTitle: element['alt_courses']['title1'],
      title: element['alt_mod_summatives']['title'],
      imageLink: element['alt_mod_summatives']['image'],
      dueDate: dueDate,
      assessedDate: status?['assessed'] != null
          ? DateTime.parse(status!['assessed'])
          : null,
      assessedBy: status?['assessed_by'] != null
          ? (status!['users']?['last'])
          : null,
      accessorId: status?['assessed_by'],
      grade: (status?['grade'] as num?)?.toDouble(),
      status: finalStatus,
      track: element['alt_courses']['course_type'],
    );
  }
}
