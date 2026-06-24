import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/tukang_provider.dart';
import '../domain/tukang_model.dart';
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
  String? _selectedCategory;

  final List<String> _categories = [
    'Listrik',
    'Ledeng',
    'AC',
    'Kunci',
    'Cat',
    'Kayu',
    'Elektronik',
    'Lainnya',
  ];

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

  void _filterByCategory(String? category) {
    setState(() {
      _selectedCategory = _selectedCategory == category ? null : category;
    });
    ref.read(tukangProvider.notifier).loadTukang(
          keahlian: _selectedCategory,
          search: _searchController.text.isNotEmpty
              ? _searchController.text
              : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tukangProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                        _filterByCategory(_selectedCategory);
                      },
                    )
                  : null,
            ),
            onSubmitted: (v) => _filterByCategory(_selectedCategory),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) => _filterByCategory(cat),
                  selectedColor: AppColors.primary.withValues(alpha: 0.15),
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : null,
                    fontWeight: isSelected ? FontWeight.w600 : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
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
    final grouped = _groupByKeahlian(state.tukangList);
    return RefreshIndicator(
      onRefresh: () => ref.read(tukangProvider.notifier).loadTukang(),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: grouped.entries.map((entry) {
          return _CategorySection(
            category: entry.key,
            tukangList: entry.value,
            isExpanded: _selectedCategory != null,
          );
        }).toList(),
      ),
    );
  }

  Map<String, List<TukangModel>> _groupByKeahlian(List<TukangModel> list) {
    final map = <String, List<TukangModel>>{};
    for (final t in list) {
      final key = t.keahlian ?? 'Lainnya';
      map.putIfAbsent(key, () => []);
      map[key]!.add(t);
    }
    final sortedKeys = map.keys.toList()..sort();
    final result = <String, List<TukangModel>>{};
    for (final k in sortedKeys) {
      result[k] = map[k]!;
    }
    return result;
  }
}

class _CategorySection extends StatelessWidget {
  final String category;
  final List<TukangModel> tukangList;
  final bool isExpanded;

  const _CategorySection({
    required this.category,
    required this.tukangList,
    this.isExpanded = false,
  });

  IconData _categoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'listrik':
        return Icons.bolt;
      case 'ledeng':
        return Icons.water_drop;
      case 'ac':
        return Icons.ac_unit;
      case 'kunci':
        return Icons.lock;
      case 'cat':
        return Icons.format_paint;
      case 'kayu':
        return Icons.handyman;
      case 'elektronik':
        return Icons.tv;
      default:
        return Icons.build;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Row(
            children: [
              Icon(_categoryIcon(category), size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${tukangList.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...tukangList.map((t) => _TukangCard(tukang: t)),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _TukangCard extends StatelessWidget {
  final TukangModel tukang;
  const _TukangCard({required this.tukang});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
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
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: AppColors.warning),
                const SizedBox(width: 4),
                Text(tukang.rating.toStringAsFixed(1)),
                const SizedBox(width: 12),
                if (tukang.alamat != null) ...[
                  const Icon(Icons.location_on, size: 16,
                      color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      tukang.alamat!,
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
