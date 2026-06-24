import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/colors.dart';

class RatingScreen extends StatefulWidget {
  final int tukangId;
  final int orderId;
  const RatingScreen({super.key, required this.tukangId, required this.orderId});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 0;
  final _reviewController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_rating == 0) return;
    setState(() => _isLoading = true);
    try {
      await ApiClient().post('/ratings', data: {
        'tukang_id': widget.tukangId,
        'order_id': widget.orderId,
        'rating': _rating,
        'review': _reviewController.text.trim(),
      });
      if (mounted) Navigator.pop(context, true);
    } catch (_) {} finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beri Rating')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Rating Anda', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) => IconButton(
                icon: Icon(i < _rating ? Icons.star : Icons.star_border, size: 40, color: AppColors.warning),
                onPressed: () => setState(() => _rating = i + 1),
              )),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _reviewController,
              decoration: const InputDecoration(labelText: 'Review (opsional)'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                  ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                  : const Text('Kirim Rating'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
