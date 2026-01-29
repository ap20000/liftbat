import 'package:equatable/equatable.dart';

class Escalation extends Equatable {
  final String id;
  final String title;
  final String severity;
  final String status;
  final DateTime timestamp;

  const Escalation({
    required this.id,
    required this.title,
    required this.severity,
    required this.status,
    required this.timestamp,
  });

  factory Escalation.fromJson(Map<String, dynamic> json) {
    return Escalation(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      severity: json['severity'] ?? '',
      status: json['status'] ?? '',
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  @override
  List<Object?> get props => [id, title, severity, status, timestamp];
}
