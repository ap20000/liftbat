import '../../domain/entities/escalation_rule.dart';

class EscalationRuleModel extends EscalationRule {
  const EscalationRuleModel({
    required super.id,
    required super.title,
    required super.description,
    required super.tier,
    required super.tierName,
  });

  factory EscalationRuleModel.fromJson(Map<String, dynamic> json) {
    return EscalationRuleModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      tier: json['tier_id'] ?? 1,
      tierName: json['tier_name'] ?? 'Low',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tier_id': tier,
      'tier_name': tierName,
    };
  }
}
