class Lesson {
  final String title;
  final int lessonId;
  List<LessonFormative> formatives;

  Lesson({
    required this.title,
    required this.lessonId,
    required this.formatives,
  });
}

class LessonFormative {
  final int formId;
  final String title;
  final String description;

  LessonFormative({
    required this.formId,
    required this.title,
    required this.description,
  });
}
