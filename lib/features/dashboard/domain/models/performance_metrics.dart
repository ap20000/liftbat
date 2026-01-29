class PerformanceMetrics {
  final double avgResponseTime;
  final double falsePositiveRate;
  final int totalAlertsToday;
  final double systemUptime;

  PerformanceMetrics({
    required this.avgResponseTime,
    required this.falsePositiveRate,
    required this.totalAlertsToday,
    required this.systemUptime,
  });

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) {
    return PerformanceMetrics(
      avgResponseTime: (json['avg_response_time'] ?? 0.0).toDouble(),
      falsePositiveRate: (json['false_positive_rate'] ?? 0.0).toDouble(),
      totalAlertsToday: json['total_alerts_today'] ?? 0,
      systemUptime: (json['system_uptime'] ?? 0.0).toDouble(),
    );
  }

  static PerformanceMetrics empty() => PerformanceMetrics(
    avgResponseTime: 0.0,
    falsePositiveRate: 0.0,
    totalAlertsToday: 0,
    systemUptime: 0.0,
  );
}
