import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              child: Text(
                (user?.name ?? '?')[0].toUpperCase(),
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(height: 16),
            Text(user?.name ?? '', style: Theme.of(context).textTheme.titleLarge),
            Text(user?.email ?? '', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  ListTile(leading: const Icon(Icons.badge), title: Text(user?.role ?? '')),
                  const Divider(),
                  ListTile(leading: const Icon(Icons.phone), title: Text(user?.phone ?? '-')),
                  const Divider(),
                  ListTile(leading: const Icon(Icons.location_on), title: Text(user?.alamat ?? '-')),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => ref.read(authStateProvider.notifier).logout(),
                icon: const Icon(Icons.logout),
                label: const Text('Keluar'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
