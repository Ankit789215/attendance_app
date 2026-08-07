class Student {
  final String id;
  final String name;
  final String phone;
  final String parentPhone;
  final String batch;
  final DateTime admissionDate;
  final String status;
  final double attendancePercentage;

  Student({
    required this.id,
    required this.name,
    required this.phone,
    required this.parentPhone,
    required this.batch,
    required this.admissionDate,
    required this.status,
    this.attendancePercentage = 0.0,
  });

  Student copyWith({
    String? id,
    String? name,
    String? phone,
    String? parentPhone,
    String? batch,
    DateTime? admissionDate,
    String? status,
    double? attendancePercentage,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      parentPhone: parentPhone ?? this.parentPhone,
      batch: batch ?? this.batch,
      admissionDate: admissionDate ?? this.admissionDate,
      status: status ?? this.status,
      attendancePercentage: attendancePercentage ?? this.attendancePercentage,
    );
  }
}
