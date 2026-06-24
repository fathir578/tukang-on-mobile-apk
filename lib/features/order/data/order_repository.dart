import '../../../core/network/api_client.dart';
import '../domain/order_model.dart';

class OrderRepository {
  final ApiClient _client = ApiClient();

  Future<List<OrderModel>> getOrders() async {
    final res = await _client.get('/orders');
    final list = res.data['data'] as List;
    return list.map((e) => OrderModel.fromJson(e)).toList();
  }

  Future<void> createOrder({
    required int tukangId,
    required String deskripsi,
    required String alamat,
  }) async {
    await _client.post('/orders', data: {
      'tukang_id': tukangId,
      'deskripsi': deskripsi,
      'alamat': alamat,
    });
  }

  Future<void> processOrder(int id) async {
    await _client.post('/orders/$id/process');
  }

  Future<void> completeOrder(int id) async {
    await _client.post('/orders/$id/complete');
  }

  Future<void> cancelOrder(int id) async {
    await _client.post('/orders/$id/cancel');
  }
}
