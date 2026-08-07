import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../attendance/domain/models/attendance.dart';
import '../../../attendance/presentation/providers/attendance_providers.dart';

// Provides a list of all attendance sessions for reporting purposes
final allAttendanceSessionsProvider = FutureProvider<List<AttendanceSession>>((ref) async {
  final repo = ref.watch(attendanceRepositoryProvider);
  return await repo.getAllSessions();
});

// A derived provider that calculates overall stats
final overallReportStatsProvider = Provider<AsyncValue<Map<String, dynamic>>>((ref) {
  final sessionsAsync = ref.watch(allAttendanceSessionsProvider);
  
  return sessionsAsync.whenData((sessions) {
    int totalClasses = sessions.length;
    int present = 0;
    int absent = 0;
    
    for (var session in sessions) {
      for (var record in session.records) {
        if (record.status == AttendanceStatus.present) {
          present++;
        } else {
          absent++;
        }
      }
    }
    
    int totalRecords = present + absent;
    double percentage = totalRecords == 0 ? 0 : (present / totalRecords) * 100;
    
    return {
      'totalClasses': totalClasses,
      'present': present,
      'absent': absent,
      'percentage': percentage,
    };
  });
});
