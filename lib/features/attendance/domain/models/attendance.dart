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
}
