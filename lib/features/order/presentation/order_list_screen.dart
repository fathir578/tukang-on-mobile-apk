import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/order_provider.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_display.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../core/constants/colors.dart';

class OrderListScreen extends ConsumerStatefulWidget {
  const OrderListScreen({super.key});

  @override
  ConsumerState<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends ConsumerState<OrderListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(orderProvider.notifier).loadOrders());
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'menunggu': return 'Menunggu';
      case 'diproses': return 'Diproses';
      case 'selesai': return 'Selesai';
      case 'dibatalkan': return 'Dibatalkan';
      default: return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'menunggu': return AppColors.warning;
      case 'diproses': return AppColors.primary;
      case 'selesai': return AppColors.success;
      case 'dibatalkan': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderProvider);
    if (state.isLoading && state.orders.isEmpty) return const LoadingWidget();
    if (state.error != null && state.orders.isEmpty) {
      return ErrorDisplay(message: state.error!, onRetry: () => ref.read(orderProvider.notifier).loadOrders());
    }
    if (state.orders.isEmpty) {
      return const EmptyStateWidget(icon: Icons.receipt_long, message: 'Belum ada pesanan');
    }
    return RefreshIndicator(
      onRefresh: () => ref.read(orderProvider.notifier).loadOrders(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.orders.length,
        itemBuilder: (_, i) {
          final order = state.orders[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(order.deskripsi, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(order.tukangName ?? ''),
              trailing: Chip(
                label: Text(_statusLabel(order.status), style: const TextStyle(fontSize: 12, color: Colors.white)),
                backgroundColor: _statusColor(order.status),
              ),
            ),
          );
        },
      ),
    );
  }
}
