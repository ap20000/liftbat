import 'package:equatable/equatable.dart';

class EscalationRule extends Equatable {
  final String id;
  final String title;
  final String description;
  final int tier;
  final String tierName;

  const EscalationRule({
    required this.id,
    required this.title,
    required this.description,
    required this.tier,
    required this.tierName,
  });

  @override
  List<Object> get props => [id, title, description, tier, tierName];
}
