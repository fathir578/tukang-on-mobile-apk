import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/user_model.dart';
import '../data/auth_repository.dart';

class AuthState {
  final bool isAuthenticated;
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserModel? user,
    bool? isLoading,
    String? error,
  }) => AuthState(
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    user: user ?? this.user,
    isLoading: isLoading ?? this.isLoading,
    error: error,
  );
}

class AuthProvider extends StateNotifier<AuthState> {
  final AuthRepository _repository = AuthRepository();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthProvider() : super(const AuthState()) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token != null) {
      try {
        final user = await _repository.getProfile();
        state = AuthState(isAuthenticated: true, user: user);
      } catch (_) {
        await _storage.delete(key: 'jwt_token');
      }
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _repository.login(email, password);
      final token = _repository.extractToken(res);
      await _storage.write(key: 'jwt_token', value: token);
      final user = UserModel.fromJson(res['user']);
      state = AuthState(isAuthenticated: true, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Login gagal');
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
    String? phone,
    String? alamat,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _repository.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        role: role,
        phone: phone,
        alamat: alamat,
      );
      final token = _repository.extractToken(res);
      await _storage.write(key: 'jwt_token', value: token);
      final user = UserModel.fromJson(res['user']);
      state = AuthState(isAuthenticated: true, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Registrasi gagal');
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
    } catch (_) {}
    await _storage.delete(key: 'jwt_token');
    state = const AuthState();
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? alamat,
  }) async {
    try {
      final user = await _repository.updateProfile(
        name: name,
        phone: phone,
        alamat: alamat,
      );
      state = state.copyWith(user: user);
    } catch (e) {
      state = state.copyWith(error: 'Gagal update profil');
    }
  }
}

final authStateProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) {
  return AuthProvider();
});
