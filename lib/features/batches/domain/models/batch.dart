class Batch {
  final String id;
  final String name;
  final String timing;
  final int numberOfStudents;

  Batch({
    required this.id,
    required this.name,
    required this.timing,
    this.numberOfStudents = 0,
  });

  Batch copyWith({
    String? id,
    String? name,
    String? timing,
    int? numberOfStudents,
  }) {
    return Batch(
      id: id ?? this.id,
      name: name ?? this.name,
      timing: timing ?? this.timing,
      numberOfStudents: numberOfStudents ?? this.numberOfStudents,
    );
  }

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      id: json['id'] as String,
      name: json['name'] as String,
      timing: json['timing'] as String,
      numberOfStudents: json['number_of_students'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'timing': timing,
      'number_of_students': numberOfStudents,
    };
  }
}
