import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/student.dart';
import '../../domain/repositories/student_repository.dart';
import '../../data/repositories/dummy_student_repository.dart';

// --- Repository Provider ---
final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return DummyStudentRepository();
});

// --- State Providers for Filtering and Searching ---
final studentSearchQueryProvider = StateProvider<String>((ref) => '');
final studentBatchFilterProvider = StateProvider<String?>((ref) => null);

// --- Students State Notifier ---
class StudentsNotifier extends StateNotifier<AsyncValue<List<Student>>> {
  final StudentRepository _repository;

  StudentsNotifier(this._repository) : super(const AsyncLoading()) {
    loadStudents();
  }

  Future<void> loadStudents() async {
    state = const AsyncLoading();
    try {
      final students = await _repository.getStudents();
      state = AsyncData(students);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> addStudent(Student student) async {
    try {
      final newStudent = await _repository.addStudent(student);
      if (state is AsyncData) {
        final currentStudents = state.value!;
        state = AsyncData([...currentStudents, newStudent]);
      }
    } catch (e) {
      // Re-throw or handle error
      rethrow;
    }
  }

  Future<void> updateStudent(Student student) async {
    try {
      final updatedStudent = await _repository.updateStudent(student);
      if (state is AsyncData) {
        final currentStudents = state.value!;
        state = AsyncData([
          for (final s in currentStudents)
            if (s.id == updatedStudent.id) updatedStudent else s
        ]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      await _repository.deleteStudent(id);
      if (state is AsyncData) {
        final currentStudents = state.value!;
        state = AsyncData(currentStudents.where((s) => s.id != id).toList());
      }
    } catch (e) {
      rethrow;
    }
  }
}

final studentsNotifierProvider = StateNotifierProvider<StudentsNotifier, AsyncValue<List<Student>>>((ref) {
  final repository = ref.watch(studentRepositoryProvider);
  return StudentsNotifier(repository);
});

// --- Filtered Students Provider ---
final filteredStudentsProvider = Provider<AsyncValue<List<Student>>>((ref) {
  final studentsState = ref.watch(studentsNotifierProvider);
  final searchQuery = ref.watch(studentSearchQueryProvider).toLowerCase();
  final batchFilter = ref.watch(studentBatchFilterProvider);

  return studentsState.whenData((students) {
    return students.where((student) {
      final matchesSearch = student.name.toLowerCase().contains(searchQuery) ||
          student.phone.contains(searchQuery);
      final matchesBatch = batchFilter == null || batchFilter == 'All' || student.batch == batchFilter;
      return matchesSearch && matchesBatch;
    }).toList();
  });
});
