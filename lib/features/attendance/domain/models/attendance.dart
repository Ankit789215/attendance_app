enum AttendanceStatus { present, absent }

class AttendanceRecord {
  final String studentId;
  final AttendanceStatus status;

  AttendanceRecord({
    required this.studentId,
    required this.status,
  });

  AttendanceRecord copyWith({
    String? studentId,
    AttendanceStatus? status,
  }) {
    return AttendanceRecord(
      studentId: studentId ?? this.studentId,
      status: status ?? this.status,
    );
  }

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      studentId: json['student_id'] as String,
      status: json['status'] == 'present' ? AttendanceStatus.present : AttendanceStatus.absent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'status': status == AttendanceStatus.present ? 'present' : 'absent',
    };
  }
}

class AttendanceSession {
  final String id;
  final String batchName;
  final DateTime date;
  final List<AttendanceRecord> records;

  AttendanceSession({
    required this.id,
    required this.batchName,
    required this.date,
    required this.records,
  });

  factory AttendanceSession.fromJson(Map<String, dynamic> json, List<AttendanceRecord> records) {
    return AttendanceSession(
      id: json['id'] as String,
      batchName: json['batch_name'] as String,
      date: DateTime.parse(json['date'] as String).toLocal(),
      records: records,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'batch_name': batchName,
      'date': date.toUtc().toIso8601String(),
    };
  }
}
