import 'package:uuid/uuid.dart';

import '../../domain/models/batch.dart';
import '../../domain/repositories/batch_repository.dart';

class DummyBatchRepository implements BatchRepository {
  final List<Batch> _batches = [
    Batch(
      id: const Uuid().v4(),
      name: 'Batch A',
      timing: '10:00 AM - 12:00 PM',
      numberOfStudents: 45,
    ),
    Batch(
      id: const Uuid().v4(),
      name: 'Batch B',
      timing: '01:00 PM - 03:00 PM',
      numberOfStudents: 32,
    ),
    Batch(
      id: const Uuid().v4(),
      name: 'Batch C',
      timing: '04:00 PM - 06:00 PM',
      numberOfStudents: 28,
    ),
  ];

  @override
  Future<List<Batch>> getBatches() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_batches);
  }

  @override
  Future<Batch> addBatch(Batch batch) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newBatch = batch.copyWith(id: const Uuid().v4());
    _batches.add(newBatch);
    return newBatch;
  }

  @override
  Future<Batch> updateBatch(Batch batch) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _batches.indexWhere((b) => b.id == batch.id);
    if (index == -1) {
      throw Exception('Batch not found');
    }
    _batches[index] = batch;
    return batch;
  }

  @override
  Future<void> deleteBatch(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _batches.removeWhere((b) => b.id == id);
  }
}
