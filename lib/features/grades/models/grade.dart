class GradeModel {
  final String title;
  final String status;
  final String grade;
  final int completion;

  GradeModel({
    required this.title,
    required this.status,
    required this.grade,
    required this.completion,
  });
}

class GradeStatus {
  static final completed = 'Completed';
  static final notStarted = 'Not Started';
  static final inProgress = 'In Progress';
}

class Grade {
  static final proficient = 'Proficient';
  static final noEvidence = 'NO EVIDENCE';
  static final emerging = 'EMERGING';
  static final metacognition = 'METACOGNITION';
}
