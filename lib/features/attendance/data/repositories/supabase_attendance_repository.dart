import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';

class SupabaseAttendanceRepository implements AttendanceRepository {
  final SupabaseClient _client;

  SupabaseAttendanceRepository(this._client);

  @override
  Future<void> saveAttendanceSession(AttendanceSession session) async {
    final userId = _client.auth.currentUser!.id;
    
    // Insert the session
    final sessionData = session.toJson();
    sessionData['user_id'] = userId;
    
    final sessionResponse = await _client
        .from('attendance_sessions')
        .insert(sessionData)
        .select()
        .single();
        
    final sessionId = sessionResponse['id'] as String;
    
    // Insert all records linked to the session
    final recordsData = session.records.map((record) {
      final data = record.toJson();
      data['session_id'] = sessionId;
      return data;
    }).toList();
    
    if (recordsData.isNotEmpty) {
      await _client.from('attendance_records').insert(recordsData);
    }
  }

  @override
  Future<List<AttendanceSession>> getSessionsForBatch(String batchName) async {
    final response = await _client
        .from('attendance_sessions')
        .select('''
          *,
          attendance_records (*)
        ''')
        .eq('batch_name', batchName)
        .order('date', ascending: false);
        
    return response.map((sessionJson) {
      final recordsJson = List<Map<String, dynamic>>.from(sessionJson['attendance_records'] as List);
      final records = recordsJson.map((json) => AttendanceRecord.fromJson(json)).toList();
      return AttendanceSession.fromJson(sessionJson, records);
    }).toList();
  }

  @override
  Future<List<AttendanceSession>> getAllSessions() async {
    final response = await _client
        .from('attendance_sessions')
        .select('''
          *,
          attendance_records (*)
        ''')
        .order('date', ascending: false);
        
    return response.map((sessionJson) {
      final recordsJson = List<Map<String, dynamic>>.from(sessionJson['attendance_records'] as List);
      final records = recordsJson.map((json) => AttendanceRecord.fromJson(json)).toList();
      return AttendanceSession.fromJson(sessionJson, records);
    }).toList();
  }
}
