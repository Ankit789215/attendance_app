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

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      parentPhone: json['parent_phone'] as String,
      batch: json['batch'] as String,
      admissionDate: DateTime.parse(json['admission_date'] as String).toLocal(),
      status: json['status'] as String,
      attendancePercentage: (json['attendance_percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'phone': phone,
      'parent_phone': parentPhone,
      'batch': batch,
      'admission_date': admissionDate.toUtc().toIso8601String(),
      'status': status,
      'attendance_percentage': attendancePercentage,
    };
  }
}
