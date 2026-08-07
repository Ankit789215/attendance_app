import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/batch.dart';
import '../../domain/repositories/batch_repository.dart';
import '../../data/repositories/dummy_batch_repository.dart';

final batchRepositoryProvider = Provider<BatchRepository>((ref) {
  return DummyBatchRepository();
});

class BatchesNotifier extends StateNotifier<AsyncValue<List<Batch>>> {
  final BatchRepository _repository;

  BatchesNotifier(this._repository) : super(const AsyncLoading()) {
    loadBatches();
  }

  Future<void> loadBatches() async {
    state = const AsyncLoading();
    try {
      final batches = await _repository.getBatches();
      state = AsyncData(batches);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> addBatch(Batch batch) async {
    try {
      final newBatch = await _repository.addBatch(batch);
      if (state is AsyncData) {
        state = AsyncData([...state.value!, newBatch]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateBatch(Batch batch) async {
    try {
      final updatedBatch = await _repository.updateBatch(batch);
      if (state is AsyncData) {
        state = AsyncData([
          for (final b in state.value!)
            if (b.id == updatedBatch.id) updatedBatch else b
        ]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteBatch(String id) async {
    try {
      await _repository.deleteBatch(id);
      if (state is AsyncData) {
        state = AsyncData(state.value!.where((b) => b.id != id).toList());
      }
    } catch (e) {
      rethrow;
    }
  }
}

final batchesNotifierProvider = StateNotifierProvider<BatchesNotifier, AsyncValue<List<Batch>>>((ref) {
  final repository = ref.watch(batchRepositoryProvider);
  return BatchesNotifier(repository);
});
