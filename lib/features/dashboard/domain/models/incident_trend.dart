class IncidentTrend {
  final String date;
  final int count;

  IncidentTrend({required this.date, required this.count});

  factory IncidentTrend.fromJson(Map<String, dynamic> json) {
    return IncidentTrend(date: json['date'] ?? '', count: json['count'] ?? 0);
  }
}
