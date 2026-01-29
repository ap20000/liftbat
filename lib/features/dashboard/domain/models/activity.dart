import 'package:equatable/equatable.dart';

class Activity extends Equatable {
  final String id;
  final String title;
  final String type;
  final DateTime timestamp;
  final String? alertId;

  const Activity({
    required this.id,
    required this.title,
    required this.type,
    required this.timestamp,
    this.alertId,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      alertId: json['alert_id'],
    );
  }

  @override
  List<Object?> get props => [id, title, type, timestamp, alertId];
}
