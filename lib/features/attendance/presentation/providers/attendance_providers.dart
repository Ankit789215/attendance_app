import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../data/repositories/supabase_attendance_repository.dart';
import '../../../students/presentation/providers/student_providers.dart';
import '../../../students/domain/models/student.dart';

// --- Repository Provider ---
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return SupabaseAttendanceRepository(Supabase.instance.client);
});

// --- Selected Batch for Attendance ---
final attendanceSelectedBatchProvider = StateProvider<String?>((ref) => null);

// --- Students to Mark Attendance For ---
// Derived by filtering the global student list by the selected batch
final attendanceStudentsListProvider = Provider<List<Student>>((ref) {
  final selectedBatch = ref.watch(attendanceSelectedBatchProvider);
  if (selectedBatch == null) return [];

  final studentsAsync = ref.watch(studentsNotifierProvider);
  return studentsAsync.when(
    data: (students) => students.where((s) => s.batch == selectedBatch).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

// --- Active Session State (Student ID -> Status) ---
class AttendanceSessionNotifier extends StateNotifier<Map<String, AttendanceStatus>> {
  AttendanceSessionNotifier() : super({});

  void initialize(List<Student> students) {
    final Map<String, AttendanceStatus> initialState = {};
    for (final student in students) {
      initialState[student.id] = AttendanceStatus.present; // Default to present
    }
    state = initialState;
  }

  void toggleStatus(String studentId) {
    if (!state.containsKey(studentId)) return;
    
    final currentStatus = state[studentId]!;
    state = {
      ...state,
      studentId: currentStatus == AttendanceStatus.present 
          ? AttendanceStatus.absent 
          : AttendanceStatus.present,
    };
  }

  void reset() {
    state = {};
  }
}

final attendanceSessionProvider = StateNotifierProvider<AttendanceSessionNotifier, Map<String, AttendanceStatus>>((ref) {
  return AttendanceSessionNotifier();
});

// --- Save Action Provider ---
final saveAttendanceProvider = FutureProvider.family<void, String>((ref, batchName) async {
  final repository = ref.read(attendanceRepositoryProvider);
  final sessionState = ref.read(attendanceSessionProvider);
  
  if (sessionState.isEmpty) return;

  final records = sessionState.entries.map((e) => 
    AttendanceRecord(studentId: e.key, status: e.value)
  ).toList();

  final session = AttendanceSession(
    id: '', // Supabase will generate the ID for the session
    batchName: batchName,
    date: DateTime.now(),
    records: records,
  );

  await repository.saveAttendanceSession(session);
});
