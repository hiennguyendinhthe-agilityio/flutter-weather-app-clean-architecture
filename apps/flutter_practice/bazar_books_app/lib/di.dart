import 'package:bazar_books_design/core/apis/api_service.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/home/bloc/product_bloc.dart';
import 'features/home/bloc/vendor_bloc.dart';
import 'features/home/data/repository.dart';
import 'features/home/data/repository_impl.dart';

class DI {
  static final DI _instance = DI._internal();

  factory DI() => _instance;

  late final Dio dio;
  late final SharedPreferences sharedPreferences;
  late final ApiService apiService;

  late final Repository repository;

  late final ProductBloc productBloc;
  late final VendorBloc vendorBloc;

  DI._internal() {
    dio = Dio();

    apiService = ApiService(dio);

    repository = RepositoryImpl(apiService);

    productBloc = ProductBloc(productRepository: repository);

    vendorBloc = VendorBloc(vendorRepository: repository);
  }
}
