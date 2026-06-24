import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/order_model.dart';
import '../../data/order_repository.dart';

class OrderState {
  final List<OrderModel> orders;
  final bool isLoading;
  final String? error;

  const OrderState({this.orders = const [], this.isLoading = false, this.error});

  OrderState copyWith({List<OrderModel>? orders, bool? isLoading, String? error}) =>
    OrderState(orders: orders ?? this.orders, isLoading: isLoading ?? this.isLoading, error: error);
}

class OrderProvider extends StateNotifier<OrderState> {
  final OrderRepository _repository = OrderRepository();

  OrderProvider() : super(const OrderState());

  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final orders = await _repository.getOrders();
      state = OrderState(orders: orders);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Gagal memuat pesanan');
    }
  }
}

final orderProvider = StateNotifierProvider<OrderProvider, OrderState>((ref) {
  return OrderProvider();
});
