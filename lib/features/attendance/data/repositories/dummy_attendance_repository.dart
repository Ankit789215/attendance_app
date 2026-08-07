import '../../domain/models/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';

class DummyAttendanceRepository implements AttendanceRepository {
  final List<AttendanceSession> _sessions = [];

  @override
  Future<void> saveAttendanceSession(AttendanceSession session) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    _sessions.add(session);
  }

  @override
  Future<List<AttendanceSession>> getSessionsForBatch(String batchName) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _sessions.where((s) => s.batchName == batchName).toList();
  }
}
