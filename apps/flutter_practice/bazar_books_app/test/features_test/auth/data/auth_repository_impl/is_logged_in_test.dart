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

  group('isLoggedIn', () {
    test('Returns true if the user exists and is logged in.', () async {
      when(() => mockIsarService.getUser())
          .thenAnswer((_) async => AuthMocks.getMockCurrentUser);

      final result = await authRepository.isLoggedIn();

      expect(result, true);
    });

    test('Returns false when there is no user in the database', () async {
      when(() => mockIsarService.getUser()).thenAnswer((_) async => null);

      final result = await authRepository.isLoggedIn();

      expect(result, false);
    });

    test('Returns false when user exists but is not logged in', () async {
      when(() => mockIsarService.getUser())
          .thenAnswer((_) async => AuthMocks.getMockUser);

      final result = await authRepository.isLoggedIn();

      expect(result, false);
    });
  });
}
