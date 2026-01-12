class SummativeLesson {
  final int dmodSumId;
  final int modnum;
  final int altid;
  final int aCid;
  final String title;
  final String task;
  final String? emergingRubric;
  final String? capableRubric;
  final String? bridgingRubric;
  final String? proficientRubric;
  final String? advancedRubric;
  final int drlid;
  final int active;
  final String? image;

  SummativeLesson({
    required this.dmodSumId,
    required this.modnum,
    required this.altid,
    required this.aCid,
    required this.title,
    required this.task,
    this.emergingRubric,
    this.capableRubric,
    this.bridgingRubric,
    this.proficientRubric,
    this.advancedRubric,
    required this.drlid,
    required this.active,
    this.image,
  });

  factory SummativeLesson.fromJson(Map<String, dynamic> json) {
    return SummativeLesson(
      dmodSumId: json['dmod_sum_id'] ?? 0,
      modnum: json['modnum'] ?? 0,
      altid: json['altid'] ?? 0,
      aCid: json['a_cid'] ?? 0,
      title: json['title'] ?? '',
      task: json['task'] ?? '',
      emergingRubric: json['emerging_rubric'],
      capableRubric: json['capable_rubric'],
      bridgingRubric: json['bridging_rubric'],
      proficientRubric: json['proficient_rubric'],
      advancedRubric: json['advanced_rubric'],
      drlid: json['drlid'] ?? 0,
      active: json['active'] ?? 0,
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dmod_sum_id': dmodSumId,
      'modnum': modnum,
      'altid': altid,
      'a_cid': aCid,
      'title': title,
      'task': task,
      'emerging_rubric': emergingRubric,
      'capable_rubric': capableRubric,
      'bridging_rubric': bridgingRubric,
      'proficient_rubric': proficientRubric,
      'advanced_rubric': advancedRubric,
      'drlid': drlid,
      'active': active,
      'image': image,
    };
  }
}
