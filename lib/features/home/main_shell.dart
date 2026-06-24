import 'package:flutter/material.dart';
import '../../features/order/presentation/order_list_screen.dart';
import '../../features/tukang/presentation/tukang_list_screen.dart';
import '../../features/dashboard/presentation/admin_dashboard_screen.dart';
import '../../features/auth/presentation/profile_screen.dart';
import '../../core/constants/colors.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    TukangListScreen(),
    OrderListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: 'Cari'),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Pesanan'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
