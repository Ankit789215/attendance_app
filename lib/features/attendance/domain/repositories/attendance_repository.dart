import '../models/attendance.dart';

abstract class AttendanceRepository {
  Future<void> saveAttendanceSession(AttendanceSession session);
  Future<List<AttendanceSession>> getSessionsForBatch(String batchName);
}
