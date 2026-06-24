import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/dashboard_provider.dart';
import '../../../core/constants/colors.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_display.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(dashboardProvider.notifier).loadStats());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Admin')),
      body: _buildContent(state),
    );
  }

  Widget _buildContent(DashboardState state) {
    if (state.isLoading && state.data == null) {
      return const LoadingWidget();
    }
    if (state.error != null && state.data == null) {
      return ErrorDisplay(
        message: state.error!,
        onRetry: () => ref.read(dashboardProvider.notifier).loadStats(),
      );
    }
    final data = state.data!;
    return RefreshIndicator(
      onRefresh: () => ref.read(dashboardProvider.notifier).loadStats(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatCard(
            title: 'Total Tukang',
            value: '${data['total_tukang'] ?? 0}',
            icon: Icons.handyman,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _StatCard(
            title: 'Total User',
            value: '${data['total_user'] ?? 0}',
            icon: Icons.people,
            color: AppColors.success,
          ),
          const SizedBox(height: 12),
          _StatCard(
            title: 'Pesanan Menunggu',
            value: '${data['total_order_menunggu'] ?? 0}',
            icon: Icons.pending_actions,
            color: AppColors.warning,
          ),
          const SizedBox(height: 12),
          _StatCard(
            title: 'Pesanan Selesai',
            value: '${data['total_order_selesai'] ?? 0}',
            icon: Icons.check_circle,
            color: AppColors.success,
          ),
          const SizedBox(height: 24),
          const Text(
            'Tukang Terbaru',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (data['recent_tukang'] != null)
            ...((data['recent_tukang'] as List).map((t) => ListTile(
                  title: Text(t['name'] ?? ''),
                  subtitle: Text(t['keahlian'] ?? ''),
                  leading: const Icon(Icons.person, color: AppColors.primary),
                ))),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(color: AppColors.textSecondary)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
