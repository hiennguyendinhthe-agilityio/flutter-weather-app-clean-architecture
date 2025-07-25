// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:new_project/services/analytics_service.dart' as _i870;
import 'package:new_project/services/config_service.dart' as _i140;
import 'package:new_project/services/counter_service.dart' as _i962;
import 'package:new_project/services/logger_service.dart' as _i959;
import 'package:new_project/services/user_service.dart' as _i1002;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i962.CounterService>(() => _i962.CounterService());
    gh.singleton<_i959.LoggerService>(() => _i959.LoggerService());
    gh.lazySingleton<_i140.ConfigService>(() => _i140.ConfigService());
    gh.factory<_i1002.UserService>(
      () => _i1002.UserService(gh<_i959.LoggerService>()),
    );
    gh.singleton<_i870.AnalyticsService>(
      () => _i870.AnalyticsService(
        gh<_i959.LoggerService>(),
        gh<_i140.ConfigService>(),
      ),
    );
    return this;
  }
}
