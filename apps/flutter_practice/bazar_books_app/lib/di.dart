import 'package:bazar_books_design/core/apis/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'features/home/data/repository.dart';
import 'features/home/data/repository_impl.dart';

final getIt = GetIt.instance;

Future<void> initGetIt() async {
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<Dio>()));

  getIt.registerLazySingleton<Repository>(
    () => RepositoryImpl(getIt<ApiService>()),
  );
}
