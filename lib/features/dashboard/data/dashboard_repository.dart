import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

class DashboardRepository {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> getStats() async {
    final res = await _client.get('/dashboard');
    return res.data['data'];
  }
}
