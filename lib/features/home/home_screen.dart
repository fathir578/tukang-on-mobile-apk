import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/tukang/presentation/tukang_list_screen.dart';
import '../../core/constants/colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tukang-On'),
        actions: [
          if (user?.role == 'admin')
            IconButton(
              icon: const Icon(Icons.dashboard),
              onPressed: () => context.push('/dashboard'),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
          ),
        ],
      ),
      body: const TukangListScreen(),
    );
  }
}
