import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/escalation_model.dart';
import '../models/escalation_rule_model.dart';

abstract class EscalationRemoteDataSource {
  Future<List<EscalationModel>> getActiveEscalations();
  Future<List<EscalationRuleModel>> getEscalationRules();
  Future<void> acknowledgeEscalation(
    String logId,
    int tierId,
    String acknowledgedBy,
  );
  Future<void> skipEscalation(String logId);
  Future<void> stopEscalation(String logId);
  Future<void> triggerEscalation(String alertId, Map<String, dynamic> data);
}

class EscalationRemoteDataSourceImpl implements EscalationRemoteDataSource {
  final Dio dio;

  EscalationRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<EscalationModel>> getActiveEscalations() async {
    try {
      final response = await dio.get('/api/active-escalations');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => EscalationModel.fromJson(e)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<EscalationRuleModel>> getEscalationRules() async {
    try {
      final response = await dio.get('/api/escalation-rules');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => EscalationRuleModel.fromJson(e)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> acknowledgeEscalation(
    String logId,
    int tierId,
    String acknowledgedBy,
  ) async {
    try {
      final response = await dio.post(
        '/api/acknowledge-escalation',
        data: {
          'escalation_log_id': logId,
          'tier_id': tierId,
          'acknowledged_by': acknowledgedBy, // Ideally taken from AuthBloc
        },
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> skipEscalation(String logId) async {
    try {
      final response = await dio.post(
        '/api/skip-escalation',
        data: {'escalation_log_id': logId},
      );
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> stopEscalation(String logId) async {
    try {
      final response = await dio.post(
        '/api/stop-escalation',
        data: {'escalation_log_id': logId},
      );
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> triggerEscalation(
    String alertId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.post(
        '/api/trigger-escalation/$alertId',
        data: data,
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
