import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/tukang_model.dart';
import '../data/tukang_repository.dart';

class TukangState {
  final List<TukangModel> tukangList;
  final bool isLoading;
  final String? error;

  const TukangState({
    this.tukangList = const [],
    this.isLoading = false,
    this.error,
  });

  TukangState copyWith({
    List<TukangModel>? tukangList,
    bool? isLoading,
    String? error,
  }) => TukangState(
    tukangList: tukangList ?? this.tukangList,
    isLoading: isLoading ?? this.isLoading,
    error: error,
  );
}

class TukangProvider extends StateNotifier<TukangState> {
  final TukangRepository _repository = TukangRepository();

  TukangProvider() : super(const TukangState());

  Future<void> loadTukang({String? search, String? keahlian}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final list = await _repository.getTukang(
        search: search,
        keahlian: keahlian,
      );
      state = TukangState(tukangList: list);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Gagal memuat data tukang',
      );
    }
  }

  Future<void> deleteTukang(int id) async {
    try {
      await _repository.deleteTukang(id);
      await loadTukang();
    } catch (e) {
      state = state.copyWith(error: 'Gagal menghapus tukang');
    }
  }
}

final tukangProvider =
    StateNotifierProvider<TukangProvider, TukangState>((ref) {
  return TukangProvider();
});
