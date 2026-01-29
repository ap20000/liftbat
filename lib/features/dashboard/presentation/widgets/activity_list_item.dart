import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ActivityListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final String? linkText;
  final VoidCallback? onLinkTap;
  final Color markerColor;

  const ActivityListItem({
    super.key,
    required this.icon,
    required this.title,
    required this.time,
    this.linkText,
    this.onLinkTap,
    this.markerColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: markerColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (linkText != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      InkWell(
                        onTap: onLinkTap,
                        child: Text(
                          linkText!,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        icon,
                        size: 14,
                        color: AppColors.primary.withOpacity(0.6),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            time,
            style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
