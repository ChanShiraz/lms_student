class LessonTool {
  final int dmodToolId;
  final int modnum;
  final int dmodLessonId;
  final int altToolId;
  final String title;
  final String description;
  final int type;
  final String? link;
  final String? path;
  final bool exist;

  LessonTool({
    required this.dmodToolId,
    required this.modnum,
    required this.dmodLessonId,
    required this.altToolId,
    required this.title,
    required this.description,
    required this.type,
    required this.exist,
    this.link,
    this.path,
  });
}

class LessonMaterial {
  final int dmodMatId;
  final int modnum;
  final int dmodLessonId;
  final String title;
  final String description;
  final int type;
  final String? link;
  final String? path;
  final bool exist;

  LessonMaterial({
    required this.dmodMatId,
    required this.modnum,
    required this.dmodLessonId,
    required this.title,
    required this.description,
    required this.type,
    required this.exist,
    this.link,
    this.path,
  });
}

class LessondMaterial {
  final int dmodMatId;
  final int modnum;
  final int dmodLessonId;
  final String title;
  final String description;
  final int type;
  final String? link;
  final String? path;
  final bool exist;

  LessondMaterial({
    required this.dmodMatId,
    required this.modnum,
    required this.dmodLessonId,
    required this.title,
    required this.description,
    required this.type,
    required this.exist,
    this.link,
    this.path,
  });
}
