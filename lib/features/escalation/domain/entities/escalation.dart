import 'package:equatable/equatable.dart';

class Escalation extends Equatable {
  final String id;
  final String title;
  final String description;
  final int tier;
  final String tierName;
  final String status; // 'active', 'acknowledged', 'resolved'
  final DateTime startedAt;
  final int timeoutSeconds;
  final int remainingSeconds;

  const Escalation({
    required this.id,
    required this.title,
    required this.description,
    required this.tier,
    required this.tierName,
    required this.status,
    required this.startedAt,
    required this.timeoutSeconds,
    this.remainingSeconds = 0,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    tier,
    tierName,
    status,
    startedAt,
    timeoutSeconds,
    remainingSeconds,
  ];
}
