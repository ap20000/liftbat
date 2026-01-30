import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/auth_interceptor.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/escalation/data/datasources/escalation_remote_data_source.dart';
import '../../features/escalation/data/repositories/escalation_repository_impl.dart';
import '../../features/escalation/domain/repositories/escalation_repository.dart';
import '../../features/escalation/domain/usecases/get_active_escalations.dart';
import '../../features/escalation/domain/usecases/acknowledge_escalation.dart';
import '../../features/escalation/domain/usecases/stop_escalation.dart';
import '../../features/escalation/domain/usecases/fetch_escalation_rules.dart';
import '../../features/escalation/domain/usecases/trigger_escalation.dart';
import '../../features/escalation/presentation/bloc/escalation_bloc.dart';
import '../../features/escalation/presentation/bloc/manual_escalation_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://predomestic-unlofty-sophie.ngrok-free.dev',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    dio.interceptors.add(AuthInterceptor());
    return dio;
  });

  // Auth
  sl.registerLazySingleton(() => AuthBloc(repository: sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl(), sharedPreferences: sl()),
  );

  // Dashboard
  sl.registerFactory(() => DashboardBloc(repository: sl()));
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(dio: sl()),
  );

  // Escalation
  sl.registerFactory(
    () => EscalationBloc(
      getActiveEscalations: sl(),
      acknowledgeEscalation: sl(),
      stopEscalation: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetActiveEscalations(sl()));
  sl.registerLazySingleton(() => AcknowledgeEscalation(sl()));
  sl.registerLazySingleton(() => StopEscalation(sl()));
  sl.registerLazySingleton(() => FetchEscalationRules(sl()));
  sl.registerLazySingleton(() => TriggerEscalation(sl()));

  sl.registerFactory(
    () => ManualEscalationBloc(
      fetchEscalationRules: sl(),
      triggerEscalation: sl(),
    ),
  );

  sl.registerLazySingleton<EscalationRepository>(
    () => EscalationRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<EscalationRemoteDataSource>(
    () => EscalationRemoteDataSourceImpl(dio: sl()),
  );
}
