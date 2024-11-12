import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../auth_mocks.dart';

void main() {
  late AuthRepositoryImpl authRepository;
  late MockApiService mockApiService;
  late MockIsarService mockIsarService;

  setUp(() {
    mockApiService = MockApiService();
    mockIsarService = MockIsarService();
    authRepository =
        AuthRepositoryImpl(mockApiService, isarService: mockIsarService);
  });

  group('getCurrentUser', () {
    test('Return User when user is in database', () async {
      when(() => mockIsarService.getUser())
          .thenAnswer((_) async => AuthMocks.getMockCurrentUser);

      final result = await authRepository.getCurrentUser();

      expect(result, equals(AuthMocks.getMockCurrentUser));
    });

    test('Return null when there is no user in the database', () async {
      when(() => mockIsarService.getUser()).thenAnswer((_) async => null);

      final result = await authRepository.getCurrentUser();

      expect(result, isNull);
    });

    test('Throw Exception when isarService.getUser fails', () async {
      when(() => mockIsarService.getUser())
          .thenThrow(Exception('Database error'));

      expect(
        () => authRepository.getCurrentUser(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
