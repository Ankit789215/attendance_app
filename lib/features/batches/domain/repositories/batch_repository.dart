import '../models/batch.dart';

abstract class BatchRepository {
  Future<List<Batch>> getBatches();
  Future<Batch> addBatch(Batch batch);
  Future<Batch> updateBatch(Batch batch);
  Future<void> deleteBatch(String id);
}
