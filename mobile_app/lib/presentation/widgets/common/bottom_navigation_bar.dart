import 'package:chilliguard/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChilliGuardBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const ChilliGuardBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // NEW: Use BottomAppBar with notch for FAB (Zepto-style)
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      elevation: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: l10n.dashboard,
              index: 0,
            ),
            _buildNavItem(
              context,
              icon: Icons.spa_outlined,
              activeIcon: Icons.spa,
              label: l10n.soilHealth,
              index: 1,
            ),
            const SizedBox(width: 48), // Space for FAB
            _buildNavItem(
              context,
              icon: Icons.agriculture_outlined,
              activeIcon: Icons.agriculture,
              label: l10n.cropManagement,
              index: 2,
            ),
            _buildNavItem(
              context,
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: l10n.profile,
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;
    final color =
        isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[600];

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(context, index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.push('/soil-health');
        break;
      case 2:
        context.push('/crop-management');
        break;
      case 3:
        context.push('/profile');
        break;
    }
  }
}
