import 'package:bazar_books_app/features/auth/data/auth_repository.dart';
import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:bazar_books_app/features/category/data/category_repository.dart';
import 'package:bazar_books_app/features/home/data/product_repository/product_repository.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'features/home/data/author_repository/author_repository.dart';
import 'features/home/data/author_repository/author_repository_impl.dart';

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

  getIt.registerLazySingleton<AuthorRepository>(
    () => AuthorRepositoryImpl(
      getIt<ApiService>(),
      getIt<ProductService>(),
    ),
  );

  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      getIt<ApiService>(),
      getIt<ProductService>(),
    ),
  );

  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        getIt<ApiService>(),
        isarService: getIt<IsarService>(),
      ));

  getIt.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(
      getIt<ApiService>(),
      isarService: getIt<IsarService>(),
    ),
  );

  getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(
        getIt<ApiService>(),
        getIt<ProductService>(),
      ));
}
