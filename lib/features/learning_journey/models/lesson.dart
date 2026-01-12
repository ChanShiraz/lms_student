class Lesson {
  final String title;
  final int dmod_lesson_id;
  List<LessonFormative> formatives;
  final bool pMaterialAccessed;
  final bool lMaterialAccessed;
  final int formativeStatus;

  Lesson({
    required this.title,
    required this.dmod_lesson_id,
    required this.formatives,
    required this.pMaterialAccessed,
    required this.lMaterialAccessed,
    required this.formativeStatus,
  });
}

class LessonFormative {
  final int formId;
  final String title;
  final String description;
  final int status;
  final int type;
  final String? link;
  final String? path;
  final String? text;

  LessonFormative({
    required this.formId,
    required this.title,
    required this.description,
    required this.status,
    required this.type,
    this.link,
    this.path,
    this.text,
  });
}
