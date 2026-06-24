import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  Color get _color {
    switch (status) {
      case 'menunggu': return AppColors.warning;
      case 'diproses': return AppColors.primary;
      case 'selesai': return AppColors.success;
      case 'dibatalkan': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  String get _label {
    switch (status) {
      case 'menunggu': return 'Menunggu';
      case 'diproses': return 'Diproses';
      case 'selesai': return 'Selesai';
      case 'dibatalkan': return 'Dibatalkan';
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(_label, style: TextStyle(color: _color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
