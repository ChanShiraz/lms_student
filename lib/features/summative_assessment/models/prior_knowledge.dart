class PriorKnowledge {
  final int dmod_pmat_id;
  final String title;
  final String description;
  final bool exist;
  final int type;
  final String? link;
  final String? path;
  final String? text;

  PriorKnowledge({
    required this.dmod_pmat_id,
    required this.title,
    required this.description,
    required this.exist,
    required this.type,
    this.link,
    this.path,
    this.text,
  });
}
