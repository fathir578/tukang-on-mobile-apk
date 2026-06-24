import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/tukang_provider.dart';
import '../../../core/constants/colors.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_display.dart';
import '../../../shared/widgets/empty_state_widget.dart';

class TukangListScreen extends ConsumerStatefulWidget {
  const TukangListScreen({super.key});

  @override
  ConsumerState<TukangListScreen> createState() => _TukangListScreenState();
}

class _TukangListScreenState extends ConsumerState<TukangListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(tukangProvider.notifier).loadTukang());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tukangProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari tukang...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(tukangProvider.notifier).loadTukang();
                      },
                    )
                  : null,
            ),
            onSubmitted: (v) =>
                ref.read(tukangProvider.notifier).loadTukang(search: v),
          ),
        ),
        Expanded(
          child: _buildContent(state),
        ),
      ],
    );
  }

  Widget _buildContent(TukangState state) {
    if (state.isLoading && state.tukangList.isEmpty) {
      return const LoadingWidget();
    }
    if (state.error != null && state.tukangList.isEmpty) {
      return ErrorDisplay(
        message: state.error!,
        onRetry: () => ref.read(tukangProvider.notifier).loadTukang(),
      );
    }
    if (state.tukangList.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.search_off,
        message: 'Tukang tidak ditemukan',
      );
    }
    return RefreshIndicator(
      onRefresh: () => ref.read(tukangProvider.notifier).loadTukang(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.tukangList.length,
        itemBuilder: (_, i) => _TukangCard(tukang: state.tukangList[i]),
      ),
    );
  }
}

class _TukangCard extends StatelessWidget {
  final dynamic tukang;
  const _TukangCard({required this.tukang});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            tukang.name[0].toUpperCase(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        title: Text(
          tukang.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tukang.keahlian != null)
              Text(tukang.keahlian,
                  style: TextStyle(color: AppColors.primary)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: AppColors.warning),
                const SizedBox(width: 4),
                Text(tukang.rating.toStringAsFixed(1)),
                const SizedBox(width: 12),
                if (tukang.alamat != null) ...[
                  const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      tukang.alamat,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: navigate to detail
        },
      ),
    );
  }
}
