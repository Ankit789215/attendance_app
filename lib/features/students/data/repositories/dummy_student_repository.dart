import 'package:uuid/uuid.dart';

import '../../domain/models/student.dart';
import '../../domain/repositories/student_repository.dart';

class DummyStudentRepository implements StudentRepository {
  final List<Student> _students = [
    Student(
      id: const Uuid().v4(),
      name: 'John Doe',
      phone: '+1234567890',
      parentPhone: '+0987654321',
      batch: 'Batch A',
      admissionDate: DateTime.now().subtract(const Duration(days: 100)),
      status: 'Active',
      attendancePercentage: 85.5,
    ),
    Student(
      id: const Uuid().v4(),
      name: 'Jane Smith',
      phone: '+1122334455',
      parentPhone: '+5544332211',
      batch: 'Batch B',
      admissionDate: DateTime.now().subtract(const Duration(days: 50)),
      status: 'Active',
      attendancePercentage: 92.0,
    ),
    Student(
      id: const Uuid().v4(),
      name: 'Mike Johnson',
      phone: '+1982736450',
      parentPhone: '+1029384756',
      batch: 'Batch A',
      admissionDate: DateTime.now().subtract(const Duration(days: 200)),
      status: 'Inactive',
      attendancePercentage: 45.0,
    ),
  ];

  @override
  Future<List<Student>> getStudents() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_students);
  }

  @override
  Future<Student> getStudentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _students.firstWhere((s) => s.id == id,
        orElse: () => throw Exception('Student not found'));
  }

  @override
  Future<Student> addStudent(Student student) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newStudent = student.copyWith(id: const Uuid().v4());
    _students.add(newStudent);
    return newStudent;
  }

  @override
  Future<Student> updateStudent(Student student) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _students.indexWhere((s) => s.id == student.id);
    if (index == -1) {
      throw Exception('Student not found');
    }
    _students[index] = student;
    return student;
  }

  @override
  Future<void> deleteStudent(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _students.removeWhere((s) => s.id == id);
  }
}
