import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/student.dart';
import '../../domain/repositories/student_repository.dart';

class SupabaseStudentRepository implements StudentRepository {
  final SupabaseClient _client;

  SupabaseStudentRepository(this._client);

  @override
  Future<List<Student>> getStudents() async {
    final response = await _client
        .from('students')
        .select()
        .order('name', ascending: true);
        
    return response.map((json) => Student.fromJson(json)).toList();
  }

  @override
  Future<Student> getStudentById(String id) async {
    final response = await _client
        .from('students')
        .select()
        .eq('id', id)
        .single();
        
    return Student.fromJson(response);
  }

  @override
  Future<Student> addStudent(Student student) async {
    final data = student.toJson();
    data['user_id'] = _client.auth.currentUser!.id;
    
    final response = await _client
        .from('students')
        .insert(data)
        .select()
        .single();
        
    return Student.fromJson(response);
  }

  @override
  Future<Student> updateStudent(Student student) async {
    final response = await _client
        .from('students')
        .update(student.toJson())
        .eq('id', student.id)
        .select()
        .single();
        
    return Student.fromJson(response);
  }

  @override
  Future<void> deleteStudent(String id) async {
    await _client.from('students').delete().eq('id', id);
  }
}
