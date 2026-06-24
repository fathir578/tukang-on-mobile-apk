import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/tukang_model.dart';
import '../data/tukang_repository.dart';
import 'providers/tukang_provider.dart';

class TukangFormScreen extends ConsumerStatefulWidget {
  final int? tukangId;
  const TukangFormScreen({super.key, this.tukangId});

  @override
  ConsumerState<TukangFormScreen> createState() => _TukangFormScreenState();
}

class _TukangFormScreenState extends ConsumerState<TukangFormScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _alamatController = TextEditingController();
  final _keahlianController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.tukangId != null) _loadTukang();
  }

  Future<void> _loadTukang() async {
    final repo = TukangRepository();
    final tukang = await repo.getTukangById(widget.tukangId!);
    _nameController.text = tukang.name;
    _phoneController.text = tukang.phone ?? '';
    _emailController.text = tukang.email ?? '';
    _alamatController.text = tukang.alamat ?? '';
    _keahlianController.text = tukang.keahlian ?? '';
    _deskripsiController.text = tukang.deskripsi ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    _keahlianController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final repo = TukangRepository();
      final data = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'alamat': _alamatController.text.trim(),
        'keahlian': _keahlianController.text.trim(),
        'deskripsi': _deskripsiController.text.trim(),
      };
      if (widget.tukangId != null) {
        await repo.updateTukang(widget.tukangId!, data);
      } else {
        await repo.createTukang(data);
      }
      if (mounted) {
        ref.read(tukangProvider.notifier).loadTukang();
        Navigator.pop(context);
      }
    } catch (e) {
      // handle error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tukangId != null ? 'Edit Tukang' : 'Tambah Tukang'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'No. Telepon'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _keahlianController,
                decoration: const InputDecoration(labelText: 'Keahlian'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : Text(widget.tukangId != null
                          ? 'Update'
                          : 'Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
