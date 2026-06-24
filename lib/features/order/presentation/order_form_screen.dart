import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../tukang/domain/tukang_model.dart';
import '../../tukang/presentation/providers/tukang_provider.dart';
import '../data/order_repository.dart';

class OrderFormScreen extends ConsumerStatefulWidget {
  const OrderFormScreen({super.key});

  @override
  ConsumerState<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends ConsumerState<OrderFormScreen> {
  final _deskripsiController = TextEditingController();
  final _alamatController = TextEditingController();
  int? _selectedTukangId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(tukangProvider.notifier).loadTukang());
  }

  @override
  void dispose() {
    _deskripsiController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedTukangId == null || _deskripsiController.text.isEmpty || _alamatController.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await OrderRepository().createOrder(
        tukangId: _selectedTukangId!,
        deskripsi: _deskripsiController.text.trim(),
        alamat: _alamatController.text.trim(),
      );
      if (mounted) context.pop();
    } catch (e) {
      // handle error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tukangState = ref.watch(tukangProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Pesan Tukang')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Pilih Tukang'),
              items: tukangState.tukangList.map((t) => DropdownMenuItem(
                value: t.id, child: Text(t.name),
              )).toList(),
              onChanged: (v) => setState(() => _selectedTukangId = v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _deskripsiController,
              decoration: const InputDecoration(labelText: 'Deskripsi Pekerjaan'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _alamatController,
              decoration: const InputDecoration(labelText: 'Alamat'),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : const Text('Kirim Pesanan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
