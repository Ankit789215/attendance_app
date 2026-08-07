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
}
