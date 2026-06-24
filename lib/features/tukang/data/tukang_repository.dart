import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../domain/tukang_model.dart';

class TukangRepository {
  final ApiClient _client = ApiClient();

  Future<List<TukangModel>> getTukang({String? search, String? keahlian}) async {
    final res = await _client.get('/tukang', query: {
      if (search != null) 'search': search,
      if (keahlian != null) 'keahlian': keahlian,
      'per_page': 50,
    });
    final list = res.data['data'] as List;
    return list.map((e) => TukangModel.fromJson(e)).toList();
  }

  Future<TukangModel> getTukangById(int id) async {
    final res = await _client.get('/tukang/$id');
    return TukangModel.fromJson(res.data['data']);
  }

  Future<void> createTukang(Map<String, dynamic> data) async {
    await _client.post('/tukang', data: data);
  }

  Future<void> updateTukang(int id, Map<String, dynamic> data) async {
    await _client.put('/tukang/$id', data: data);
  }

  Future<void> deleteTukang(int id) async {
    await _client.delete('/tukang/$id');
  }
}
