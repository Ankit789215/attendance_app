import '../models/student.dart';

abstract class StudentRepository {
  Future<List<Student>> getStudents();
  Future<Student> getStudentById(String id);
  Future<Student> addStudent(Student student);
  Future<Student> updateStudent(Student student);
  Future<void> deleteStudent(String id);
}
