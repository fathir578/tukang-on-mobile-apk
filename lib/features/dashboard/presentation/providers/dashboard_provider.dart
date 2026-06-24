import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/dashboard_repository.dart';

class DashboardState {
  final Map<String, dynamic>? data;
  final bool isLoading;
  final String? error;

  const DashboardState({this.data, this.isLoading = false, this.error});

  DashboardState copyWith({
    Map<String, dynamic>? data,
    bool? isLoading,
    String? error,
  }) => DashboardState(
    data: data ?? this.data,
    isLoading: isLoading ?? this.isLoading,
    error: error,
  );
}

class DashboardProvider extends StateNotifier<DashboardState> {
  final DashboardRepository _repository = DashboardRepository();

  DashboardProvider() : super(const DashboardState());

  Future<void> loadStats() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _repository.getStats();
      state = DashboardState(data: data);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Gagal memuat dashboard');
    }
  }
}

final dashboardProvider = StateNotifierProvider<DashboardProvider, DashboardState>((ref) {
  return DashboardProvider();
});
