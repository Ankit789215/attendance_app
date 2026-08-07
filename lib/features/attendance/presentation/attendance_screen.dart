import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../domain/models/attendance.dart';
import 'providers/attendance_providers.dart';
import '../../batches/presentation/providers/batch_providers.dart';
import '../../students/domain/models/student.dart';
import '../../students/presentation/providers/student_providers.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  bool _isSaving = false;

  void _onBatchChanged(String? newBatch, List<Student> nextStudents) {
    ref.read(attendanceSelectedBatchProvider.notifier).state = newBatch;
    if (newBatch != null) {
      // Re-initialize state when batch changes
      Future.delayed(Duration.zero, () {
        ref.read(attendanceSessionProvider.notifier).initialize(nextStudents);
      });
    }
  }

  Future<void> _saveAttendance(String batchName) async {
    setState(() => _isSaving = true);
    
    try {
      final records = ref.read(attendanceSessionProvider);
      final repo = ref.read(attendanceRepositoryProvider);
      
      final session = AttendanceSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        batchName: batchName,
        date: DateTime.now(),
        records: records.entries.map((e) => AttendanceRecord(studentId: e.key, status: e.value)).toList(),
      );

      await repo.saveAttendanceSession(session);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attendance saved successfully!'), backgroundColor: Colors.green),
        );
        // Reset screen
        ref.read(attendanceSelectedBatchProvider.notifier).state = null;
        ref.read(attendanceSessionProvider.notifier).reset();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedBatch = ref.watch(attendanceSelectedBatchProvider);
    final students = ref.watch(attendanceStudentsListProvider);
    final sessionState = ref.watch(attendanceSessionProvider);

    final batchesAsync = ref.watch(batchesNotifierProvider);

    int presentCount = sessionState.values.where((s) => s == AttendanceStatus.present).length;
    int absentCount = sessionState.values.where((s) => s == AttendanceStatus.absent).length;

    // Listen to changes in the students list (e.g. when batch is selected) to initialize the state
    ref.listen<List<Student>>(attendanceStudentsListProvider, (previous, next) {
      if (selectedBatch != null && (previous == null || previous.isEmpty) && next.isNotEmpty) {
         ref.read(attendanceSessionProvider.notifier).initialize(next);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Batch Selector Header
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: batchesAsync.when(
              data: (batches) {
                if (batches.isEmpty) {
                  return const Text('No batches available. Please create a batch first.');
                }
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedBatch,
                      hint: const Text('Select a Batch'),
                      items: batches.map((b) => DropdownMenuItem(value: b.name, child: Text(b.name))).toList(),
                      onChanged: (val) {
                         // Find students for the newly selected batch to initialize them
                         final allStudents = ref.read(studentsNotifierProvider).value ?? [];
                         final nextStudents = allStudents.where((s) => s.batch == val).toList();
                         _onBatchChanged(val, nextStudents);
                      },
                    ),
                  ),
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (err, stack) => Text('Error loading batches: $err'),
            ),
          ),
          
          const Divider(height: 1),

          // Student List
          Expanded(
            child: selectedBatch == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.touch_app, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text('Select a batch to begin', style: TextStyle(color: Colors.grey.shade600, fontSize: 18)),
                      ],
                    ).animate().fade().scale(curve: Curves.easeOut),
                  )
                : students.isEmpty
                    ? const Center(child: Text('No students found in this batch.'))
                    : ListView.separated(
                        padding: const EdgeInsets.only(top: 8, bottom: 100), // padding for bottom bar
                        itemCount: students.length,
                        separatorBuilder: (context, index) => const Divider(indent: 72, height: 1),
                        itemBuilder: (context, index) {
                          final student = students[index];
                          final status = sessionState[student.id] ?? AttendanceStatus.present;
                          final isPresent = status == AttendanceStatus.present;

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                            leading: CircleAvatar(
                              backgroundColor: isPresent 
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                              child: Text(
                                student.name[0].toUpperCase(),
                                style: TextStyle(
                                  color: isPresent ? Colors.green.shade700 : Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                            subtitle: Text(student.phone, style: TextStyle(color: Colors.grey.shade600)),
                            trailing: GestureDetector(
                              onTap: () => ref.read(attendanceSessionProvider.notifier).toggleStatus(student.id),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isPresent ? Colors.green : Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isPresent ? Colors.green : Colors.red.shade200,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    isPresent ? 'Present' : 'Absent',
                                    style: TextStyle(
                                      color: isPresent ? Colors.white : Colors.red.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () => ref.read(attendanceSessionProvider.notifier).toggleStatus(student.id),
                          ).animate().fade(delay: (50 * index).ms).slideX(begin: 0.05);
                        },
                      ),
          ),
        ],
      ),

      // Bottom Summary & Save Bar
      bottomNavigationBar: selectedBatch != null && students.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total: ${students.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text('P: $presentCount', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                              const SizedBox(width: 16),
                              Text('A: $absentCount', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: _isSaving ? null : () => _saveAttendance(selectedBatch),
                      icon: _isSaving 
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.check_circle_outline),
                      label: Text(_isSaving ? 'Saving...' : 'Save Attendance'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().slideY(begin: 1.0, curve: Curves.easeOut)
          : null,
    );
  }
}
