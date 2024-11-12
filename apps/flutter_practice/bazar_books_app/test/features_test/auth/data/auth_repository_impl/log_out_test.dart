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

  group('logOut', () {
    test('Successfully calls logoutDB from isarService', () async {
      when(() => mockIsarService.logoutDB()).thenAnswer((_) async {});

      await authRepository.logOut();

      verify(() => mockIsarService.logoutDB()).called(1);
    });

    test('Throws Exception when logoutDB fails', () async {
      when(() => mockIsarService.logoutDB()).thenThrow(AuthMocks.failureMock);

      expect(
        () => authRepository.logOut(),
        throwsA(isA<Exception>()),
      );

      verify(() => mockIsarService.logoutDB()).called(1);
    });
  });
}
