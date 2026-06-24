import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../domain/user_model.dart';

class AuthRepository {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _client.post('/login', data: {
      'email': email,
      'password': password,
    });
    return res.data;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
    String? phone,
    String? alamat,
  }) async {
    final res = await _client.post('/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'role': role,
      'phone': phone,
      'alamat': alamat,
    });
    return res.data;
  }

  Future<UserModel> getProfile() async {
    final res = await _client.get('/me');
    return UserModel.fromJson(res.data['data']);
  }

  Future<void> logout() async {
    await _client.post('/logout');
  }

  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? alamat,
  }) async {
    final res = await _client.put('/profile', data: {
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (alamat != null) 'alamat': alamat,
    });
    return UserModel.fromJson(res.data['data']);
  }

  String extractToken(Map<String, dynamic> response) {
    return response['token'] ?? response['data']['token'] ?? '';
  }
}
