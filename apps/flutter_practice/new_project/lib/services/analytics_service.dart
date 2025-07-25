import 'package:injectable/injectable.dart';

import 'config_service.dart';
import 'logger_service.dart';

@singleton
class AnalyticsService {
  final LoggerService _loggerService;
  final ConfigService _configService;
  int _eventCount = 0;

  AnalyticsService(this._loggerService, this._configService) {
    _loggerService.log('[AnalyticsService] Singleton initialized');
    _loggerService.logInfo('Analytics enabled for ${_configService.appName}');
  }

  int get eventCount => _eventCount;

  void trackEvent(String eventName) {
    _eventCount++;
    _loggerService.log('📊 Event tracked: $eventName (Total: $_eventCount)');

    if (_configService.isDebugMode) {
      _loggerService.logInfo('Debug mode: Event details logged');
    }
  }

  void trackScreenView(String screenName) {
    trackEvent('screen_view_$screenName');
  }

  String getAnalyticsInfo() {
    return 'Analytics: $_eventCount events tracked';
  }
}
