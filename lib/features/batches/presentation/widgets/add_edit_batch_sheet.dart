import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/batch.dart';
import '../providers/batch_providers.dart';

class AddEditBatchSheet extends ConsumerStatefulWidget {
  final Batch? batch;

  const AddEditBatchSheet({super.key, this.batch});

  @override
  ConsumerState<AddEditBatchSheet> createState() => _AddEditBatchSheetState();
}

class _AddEditBatchSheetState extends ConsumerState<AddEditBatchSheet> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _timingController;
  late TextEditingController _studentsCountController;

  @override
  void initState() {
    super.initState();
    final batch = widget.batch;
    _nameController = TextEditingController(text: batch?.name ?? '');
    _timingController = TextEditingController(text: batch?.timing ?? '');
    _studentsCountController = TextEditingController(
        text: batch != null ? batch.numberOfStudents.toString() : '0');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timingController.dispose();
    _studentsCountController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(batchesNotifierProvider.notifier);
      final numStudents = int.tryParse(_studentsCountController.text) ?? 0;
      
      if (widget.batch == null) {
        // Add
        final newBatch = Batch(
          id: '', // Handled by repository
          name: _nameController.text.trim(),
          timing: _timingController.text.trim(),
          numberOfStudents: numStudents,
        );
        notifier.addBatch(newBatch);
      } else {
        // Edit
        final updatedBatch = widget.batch!.copyWith(
          name: _nameController.text.trim(),
          timing: _timingController.text.trim(),
          numberOfStudents: numStudents,
        );
        notifier.updateBatch(updatedBatch);
      }
      
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.batch != null;
    
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
                      isEdit ? 'Edit Batch' : 'Add Batch',
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
                    labelText: 'Batch Name',
                    prefixIcon: Icon(Icons.class_),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _timingController,
                  decoration: const InputDecoration(
                    labelText: 'Timing (e.g. 10:00 AM - 12:00 PM)',
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Timing is required' : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _studentsCountController,
                  decoration: const InputDecoration(
                    labelText: 'Number of Students',
                    prefixIcon: Icon(Icons.people),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (int.tryParse(v) == null) return 'Must be a number';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                FilledButton(
                  onPressed: _saveForm,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(isEdit ? 'Save Changes' : 'Add Batch', style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
