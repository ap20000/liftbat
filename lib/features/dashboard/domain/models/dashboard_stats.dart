import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final int active;
  final int critical;
  final int resolved;

  const DashboardStats({
    required this.active,
    required this.critical,
    required this.resolved,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      active: json['active'] ?? 0,
      critical: json['critical'] ?? 0,
      resolved: json['resolved'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [active, critical, resolved];
}
