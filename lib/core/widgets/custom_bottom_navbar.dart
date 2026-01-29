import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lift/core/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_outlined,
            label: 'Home',
            isSelected: location == '/dashboard',
            onTap: () => context.go('/dashboard'),
          ),
          _NavItem(
            icon: Icons.assignment_outlined,
            label: 'My work',
            isSelected: location == '/tasks',
            onTap: () => context.go('/tasks'),
          ),
          _NavItem(
            icon: Icons.description_outlined,
            label: 'Reports',
            isSelected: location == '/reports',
            onTap: () => context.go('/reports'),
          ),
          _NavItem(
            icon: Icons.more_horiz_rounded,
            label: 'More',
            isSelected: location == '/more',
            onTap: () => context.go('/more'),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.textTertiary;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
