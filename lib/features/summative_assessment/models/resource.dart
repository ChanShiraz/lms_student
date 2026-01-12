class Resource {
  final String? description;
  final int type;
  final String value;
  int id;
  final int modnum;
  Resource({
    this.description,
    required this.type,
    required this.value,
    required this.id,
    required this.modnum,
  });

  Map<String, dynamic> toMap(int dmodSumId) {
    return <String, dynamic>{
      'description': description,
      'type': type,
      'link': value,
      'dmod_sum_id': dmodSumId,
      'modnum': modnum,
    };
  }

  factory Resource.fromMap(Map<String, dynamic> map) {
    return Resource(
      description: map['description'] != null
          ? map['description'] as String
          : '',
      type: map['type'] as int,
      modnum: map['modnum'] as int,
      value: map['link'] as String,
      id: map['dmod_sum_id'] as int,
    );
  }
}
