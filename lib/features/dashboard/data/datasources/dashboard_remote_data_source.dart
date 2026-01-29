import 'package:dio/dio.dart';
import '../../domain/models/dashboard_stats.dart';
import '../../domain/models/activity.dart';
import '../../domain/models/escalation.dart';
import '../../domain/models/incident.dart';
import '../../domain/models/incident_trend.dart';
import '../../domain/models/performance_metrics.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStats> getStats();
  Future<List<Incident>> getIncidents();
  Future<List<Activity>> getActivities();
  Future<List<Escalation>> getActiveEscalations();
  Future<void> acknowledgeEscalation(String alertId);
  Future<void> triggerEscalation(String alertId);
  Future<void> stopEscalation();
  Future<PerformanceMetrics> getPerformanceMetrics();
  Future<List<IncidentTrend>> getIncidentTrends();
  Future<void> exportReportBundle();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSourceImpl({required this.dio});

  @override
  Future<DashboardStats> getStats() async {
    final response = await dio.get('/api/incidents/stats/status');
    final data = response.data;
    if (data is Map<String, dynamic>) {
      if (data.containsKey('active') || data.containsKey('critical')) {
        return DashboardStats.fromJson(data);
      } else if (data.containsKey('data') &&
          data['data'] is Map<String, dynamic>) {
        return DashboardStats.fromJson(data['data']);
      }
    }
    return DashboardStats.fromJson(data);
  }

  @override
  Future<List<Incident>> getIncidents() async {
    final response = await dio.get('/api/incidents');
    final data = response.data;
    List list;
    if (data is List) {
      list = data;
    } else if (data is Map &&
        data.containsKey('data') &&
        data['data'] is List) {
      list = data['data'];
    } else if (data is Map &&
        data.containsKey('incidents') &&
        data['incidents'] is List) {
      list = data['incidents'];
    } else {
      throw const FormatException('Invalid response format for incidents');
    }
    return list.map((json) => Incident.fromJson(json)).toList();
  }

  @override
  Future<List<Activity>> getActivities() async {
    final response = await dio.get('/api/activities');
    final data = response.data;
    List list;
    if (data is List) {
      list = data;
    } else if (data is Map &&
        data.containsKey('data') &&
        data['data'] is List) {
      list = data['data'];
    } else if (data is Map &&
        data.containsKey('activities') &&
        data['activities'] is List) {
      list = data['activities'];
    } else {
      throw const FormatException('Invalid response format for activities');
    }
    return list.map((json) => Activity.fromJson(json)).toList();
  }

  @override
  Future<List<Escalation>> getActiveEscalations() async {
    final response = await dio.get('/api/active-escalations');
    final data = response.data;
    List list;
    if (data is List) {
      list = data;
    } else if (data is Map &&
        data.containsKey('data') &&
        data['data'] is List) {
      list = data['data'];
    } else if (data is Map &&
        data.containsKey('escalations') &&
        data['escalations'] is List) {
      list = data['escalations'];
    } else {
      throw const FormatException(
        'Invalid response format for active-escalations',
      );
    }
    return list.map((json) => Escalation.fromJson(json)).toList();
  }

  @override
  Future<void> acknowledgeEscalation(String alertId) async {
    await dio.post('/api/acknowledge-escalation', data: {'alert_id': alertId});
  }

  @override
  Future<void> triggerEscalation(String alertId) async {
    await dio.post('/api/trigger-escalation/$alertId');
  }

  @override
  Future<void> stopEscalation() async {
    await dio.post('/api/stop-escalation');
  }

  @override
  Future<PerformanceMetrics> getPerformanceMetrics() async {
    final response = await dio.get('/api/analytics/performance');
    final data = response.data;
    if (data is Map<String, dynamic> &&
        data.containsKey('data') &&
        data['data'] is Map<String, dynamic>) {
      return PerformanceMetrics.fromJson(data['data']);
    }
    return PerformanceMetrics.fromJson(data);
  }

  @override
  Future<List<IncidentTrend>> getIncidentTrends() async {
    final response = await dio.get('/api/incidents/trends');
    final data = response.data;
    List list;
    if (data is List) {
      list = data;
    } else if (data is Map &&
        data.containsKey('data') &&
        data['data'] is List) {
      list = data['data'];
    } else {
      return [];
    }
    return list.map((json) => IncidentTrend.fromJson(json)).toList();
  }

  @override
  Future<void> exportReportBundle() async {
    await dio.post('/api/export/report-bundle');
  }
}
