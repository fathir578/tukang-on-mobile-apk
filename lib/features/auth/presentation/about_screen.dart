import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.handyman, size: 80, color: AppColors.primary),
              const SizedBox(height: 16),
              const Text('Tukang-On', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('v1.0.0', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              const Text('Aplikasi pencarian dan pemesanan tukang servis terpercaya.'),
            ],
          ),
        ),
      ),
    );
  }
}
