import 'package:bazar_books_design/core/apis/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/home/data/repository.dart';
import 'features/home/data/repository_impl.dart';

final getIt = GetIt.instance;

Future<void> initGetIt() async {
  getIt.registerLazySingleton<Dio>(() => Dio());

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<Dio>()));

  getIt.registerLazySingleton<Repository>(
    () => RepositoryImpl(getIt<ApiService>()),
  );
}
