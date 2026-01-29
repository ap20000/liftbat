import 'package:flutter/material.dart';

class ActivityItemWidget extends StatelessWidget {
  final String title;
  final String timestamp;
  final Color dotColor;

  const ActivityItemWidget({
    super.key,
    required this.title,
    required this.timestamp,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title)),
          Text(
            timestamp,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
