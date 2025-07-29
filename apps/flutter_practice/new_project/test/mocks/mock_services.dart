import 'package:mocktail/mocktail.dart';
import 'package:new_project/models/user_model.dart';
import 'package:new_project/services/auth_service.dart';
import 'package:new_project/services/dio_service.dart';
import 'package:new_project/services/logger_service.dart';
import 'package:new_project/services/user_api_service.dart';
import 'package:new_project/services/user_service.dart';

/// Mock classes for testing
/// Sử dụng mocktail để tạo fake implementations

// Mock Services
class MockLoggerService extends Mock implements LoggerService {}

class MockUserService extends Mock implements UserService {}

class MockDioService extends Mock implements DioService {}

class MockUserApiService extends Mock implements UserApiService {}

class MockAuthService extends Mock implements AuthService {}

// Mock Models (nếu cần)
class MockApiUser extends Mock implements ApiUser {}

/// Helper class để setup common mocks
class MockSetupHelper {
  /// Setup mock logger service với default behaviors
  static MockLoggerService setupMockLogger() {
    final mockLogger = MockLoggerService();

    // Setup default behaviors - không throw exception
    when(() => mockLogger.log(any())).thenReturn(null);
    when(() => mockLogger.logInfo(any())).thenReturn(null);
    when(() => mockLogger.logError(any())).thenReturn(null);

    return mockLogger;
  }

  /// Setup mock user service với default behaviors
  static MockUserService setupMockUserService() {
    final mockUserService = MockUserService();

    // Setup default behaviors
    when(() => mockUserService.getCurrentUser()).thenReturn('mock_user_123');
    when(() => mockUserService.logout()).thenReturn(null);

    return mockUserService;
  }

  /// Setup mock user API service
  static MockUserApiService setupMockUserApiService() {
    final mockUserApiService = MockUserApiService();

    // Setup default API responses
    when(() => mockUserApiService.getUsers()).thenAnswer(
      (_) async => [
        const ApiUser(id: '1', name: 'Test User 1', email: 'test1@example.com'),
        const ApiUser(id: '2', name: 'Test User 2', email: 'test2@example.com'),
      ],
    );

    return mockUserApiService;
  }

  /// Create mock API user
  static ApiUser createMockApiUser({
    String id = '1',
    String name = 'Test User',
    String email = 'test@example.com',
    String? avatar,
    String? phone,
    String? address,
  }) {
    return ApiUser(
      id: id,
      name: name,
      email: email,
      avatar: avatar,
      phone: phone,
      address: address,
    );
  }

  /// Create mock login response
  static MockLoginResponse createMockLoginResponse({
    String token = 'mock_token_123',
    ApiUser? user,
    int expiresIn = 3600,
  }) {
    user ??= createMockApiUser();

    return MockLoginResponse(token: token, user: user, expiresIn: expiresIn);
  }
}
