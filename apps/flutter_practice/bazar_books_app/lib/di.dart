import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'features/home/data/repository.dart';
import 'features/home/data/repository_impl.dart';

final getIt = GetIt.instance;

Future<void> initGetIt() async {
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<Dio>()));

  getIt.registerLazySingleton<IsarService>(
    () => IsarService(),
  );

  getIt.registerLazySingleton<ProductService>(
    () => ProductService(getIt<Dio>(), isarService: getIt<IsarService>()),
  );

  getIt.registerLazySingleton<Repository>(
    () => RepositoryImpl(
      getIt<ApiService>(),
      getIt<ProductService>(),
    ),
  );
}
