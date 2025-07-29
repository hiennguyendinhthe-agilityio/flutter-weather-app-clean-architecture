// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_auth_demo/core/di/injection.dart' as _i451;
import 'package:flutter_auth_demo/data/datasources/api_client.dart' as _i868;
import 'package:flutter_auth_demo/data/services/auth_service.dart' as _i393;
import 'package:flutter_auth_demo/data/services/storage_service.dart' as _i629;
import 'package:flutter_auth_demo/presentation/providers/user_provider.dart'
    as _i302;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i361.Dio>(() => registerModule.dio);
    gh.singleton<_i629.StorageService>(
      () => _i629.StorageService(gh<_i460.SharedPreferences>()),
    );
    gh.singleton<_i868.ApiClient>(() => _i868.ApiClient(gh<_i361.Dio>()));
    gh.singleton<_i393.AuthService>(
      () =>
          _i393.AuthService(gh<_i868.ApiClient>(), gh<_i629.StorageService>()),
    );
    gh.singleton<_i302.UserProvider>(
      () => _i302.UserProvider(gh<_i393.AuthService>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i451.RegisterModule {}
