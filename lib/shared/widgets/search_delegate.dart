import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class TukangSearchDelegate extends SearchDelegate<String?> {
  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) =>
    IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => _buildEmpty();

  @override
  Widget buildSuggestions(BuildContext context) => _buildEmpty();

  Widget _buildEmpty() => const Center(
    child: Text('Ketik untuk mencari tukang', style: TextStyle(color: AppColors.textSecondary)),
  );
}
