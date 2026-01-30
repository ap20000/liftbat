import '../../domain/entities/escalation.dart';

class EscalationModel extends Escalation {
  const EscalationModel({
    required super.id,
    required super.title,
    required super.description,
    required super.tier,
    required super.tierName,
    required super.status,
    required super.startedAt,
    required super.timeoutSeconds,
    super.remainingSeconds,
  });

  factory EscalationModel.fromJson(Map<String, dynamic> json) {
    return EscalationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Unknown Escalation',
      description: json['description'] ?? '',
      tier: json['tier'] is int ? json['tier'] : 1,
      tierName: json['tier_name'] ?? 'Tier 1',
      status: json['status'] ?? 'active',
      startedAt: DateTime.tryParse(json['started_at'] ?? '') ?? DateTime.now(),
      timeoutSeconds: json['timeout_seconds'] is int
          ? json['timeout_seconds']
          : (json['timeout_seconds'] is String
                ? int.tryParse(json['timeout_seconds']) ?? 60
                : 60),
      remainingSeconds: json['remaining_seconds'] is int
          ? json['remaining_seconds']
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tier': tier,
      'tier_name': tierName,
      'status': status,
      'started_at': startedAt.toIso8601String(),
      'timeout_seconds': timeoutSeconds,
      'remaining_seconds': remainingSeconds,
    };
  }
}
