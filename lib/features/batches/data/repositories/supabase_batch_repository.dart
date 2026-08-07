import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/batch.dart';
import '../../domain/repositories/batch_repository.dart';

class SupabaseBatchRepository implements BatchRepository {
  final SupabaseClient _client;

  SupabaseBatchRepository(this._client);

  @override
  Future<List<Batch>> getBatches() async {
    final response = await _client
        .from('batches')
        .select()
        .order('created_at', ascending: true);
        
    return response.map((json) => Batch.fromJson(json)).toList();
  }

  @override
  Future<Batch> addBatch(Batch batch) async {
    final data = batch.toJson();
    data['user_id'] = _client.auth.currentUser!.id;
    
    final response = await _client
        .from('batches')
        .insert(data)
        .select()
        .single();
        
    return Batch.fromJson(response);
  }

  @override
  Future<Batch> updateBatch(Batch batch) async {
    final response = await _client
        .from('batches')
        .update(batch.toJson())
        .eq('id', batch.id)
        .select()
        .single();
        
    return Batch.fromJson(response);
  }

  @override
  Future<void> deleteBatch(String id) async {
    await _client.from('batches').delete().eq('id', id);
  }
}
