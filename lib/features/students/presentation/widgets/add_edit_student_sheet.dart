import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/validators.dart';
import '../../domain/models/student.dart';
import '../providers/student_providers.dart';

class AddEditStudentSheet extends ConsumerStatefulWidget {
  final Student? student; // If null, it's 'Add'. If provided, it's 'Edit'.

  const AddEditStudentSheet({super.key, this.student});

  @override
  ConsumerState<AddEditStudentSheet> createState() => _AddEditStudentSheetState();
}

class _AddEditStudentSheetState extends ConsumerState<AddEditStudentSheet> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _parentPhoneController;
  
  String _selectedBatch = 'Batch A';
  String _selectedStatus = 'Active';
  DateTime _admissionDate = DateTime.now();

  final List<String> _batches = ['Batch A', 'Batch B', 'Batch C'];
  final List<String> _statuses = ['Active', 'Inactive'];

  @override
  void initState() {
    super.initState();
    final student = widget.student;
    _nameController = TextEditingController(text: student?.name ?? '');
    _phoneController = TextEditingController(text: student?.phone ?? '');
    _parentPhoneController = TextEditingController(text: student?.parentPhone ?? '');
    
    if (student != null) {
      _selectedBatch = student.batch;
      _selectedStatus = student.status;
      _admissionDate = student.admissionDate;
      // Ensure batch exists in list or add it temporarily
      if (!_batches.contains(_selectedBatch)) {
        _batches.add(_selectedBatch);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _parentPhoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _admissionDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _admissionDate) {
      setState(() {
        _admissionDate = picked;
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(studentsNotifierProvider.notifier);
      
      if (widget.student == null) {
        // Add
        final newStudent = Student(
          id: '', // Will be assigned by repository
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          parentPhone: _parentPhoneController.text.trim(),
          batch: _selectedBatch,
          admissionDate: _admissionDate,
          status: _selectedStatus,
          attendancePercentage: 0.0,
        );
        notifier.addStudent(newStudent);
      } else {
        // Edit
        final updatedStudent = widget.student!.copyWith(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          parentPhone: _parentPhoneController.text.trim(),
          batch: _selectedBatch,
          admissionDate: _admissionDate,
          status: _selectedStatus,
        );
        notifier.updateStudent(updatedStudent);
      }
      
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.student != null;
    
    return Padding(
      // Padding for keyboard
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEdit ? 'Edit Student' : 'Add Student',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _parentPhoneController,
                        decoration: const InputDecoration(
                          labelText: 'Parent Phone',
                          prefixIcon: Icon(Icons.phone_android),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedBatch,
                        decoration: const InputDecoration(
                          labelText: 'Batch',
                          prefixIcon: Icon(Icons.class_),
                        ),
                        items: _batches.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                        onChanged: (v) => setState(() => _selectedBatch = v!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          prefixIcon: Icon(Icons.toggle_on),
                        ),
                        items: _statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (v) => setState(() => _selectedStatus = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Admission Date',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(DateFormat('yyyy-MM-dd').format(_admissionDate)),
                  ),
                ),
                const SizedBox(height: 24),
                
                FilledButton(
                  onPressed: _saveForm,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(isEdit ? 'Save Changes' : 'Add Student', style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
