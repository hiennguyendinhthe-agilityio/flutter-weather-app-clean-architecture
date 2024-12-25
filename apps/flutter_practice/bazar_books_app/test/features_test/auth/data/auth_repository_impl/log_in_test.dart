// import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
// import 'package:bazar_books_design/core/network/failure.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// import '../../auth_mocks.dart';

// void main() {
//   late AuthRepositoryImpl authRepository;
//   late MockApiService mockApiService;
//   late MockIsarService mockIsarService;
//   setUpAll(() {
//     registerFallbackValue(FakeUser());
//   });

//   setUp(() {
//     mockApiService = MockApiService();
//     mockIsarService = MockIsarService();
//     authRepository =
//         AuthRepositoryImpl(mockApiService, isarService: mockIsarService);
//   });

//   group('AuthRepositoryImpl - logIn', () {
//     test('should return an existing user from IsarService if already logged in',
//         () async {
//       // Arrange
//       when(() => mockIsarService.getLoggedInUser())
//           .thenAnswer((_) async => AuthMocks.getMockCurrentUser);

//       // Act
//       final result = await authRepository.logIn(
//           AuthMocks.getMockEmail, AuthMocks.getMockPassword);

//       // Assert
//       expect(result, equals(AuthMocks.getMockCurrentUser));
//       verify(() => mockIsarService.getLoggedInUser()).called(1);
//       verifyNever(() => mockApiService.logIn(
//           AuthMocks.getMockEmail, AuthMocks.getMockPassword));
//     });

//     test('should throw Failure if an exception occurs', () async {
//       // Arrange
//       when(() => mockIsarService.getLoggedInUser()).thenThrow(
//         DioException(
//           message: "Request was cancelled.",
//           requestOptions: RequestOptions(path: '/user-info'),
//         ),
//       );

//       // Act & Assert
//       await expectLater(
//         authRepository.logIn(
//           AuthMocks.getMockEmail,
//           AuthMocks.getMockPassword,
//         ),
//         throwsA(isA<Failure>()),
//       );
//     });
//     test(
//         'should return a user from ApiService and save to IsarService if not already logged in',
//         () async {
//       // Arrange
//       when(() => mockIsarService.getLoggedInUser())
//           .thenAnswer((_) async => null);
//       when(() => mockApiService.logIn(
//             AuthMocks.getMockEmail,
//             AuthMocks.getMockPassword,
//           )).thenAnswer((_) async => AuthMocks.getMockCurrentUser);
//       when(() => mockIsarService.saveUser(any())).thenAnswer((_) async {});

//       // Act
//       final result = await authRepository.logIn(
//         AuthMocks.getMockEmail,
//         AuthMocks.getMockPassword,
//       );

//       // Assert
//       expect(result, isNotNull);
//       expect(result?.isLoggedIn, isTrue);
//     });

//     test('should throw Failure if ApiService.logIn throws an exception',
//         () async {
//       // Arrange
//       when(() => mockIsarService.getLoggedInUser())
//           .thenAnswer((_) async => null);
//       when(() => mockApiService.logIn(
//             AuthMocks.getMockEmail,
//             AuthMocks.getMockPassword,
//           )).thenThrow(
//         DioException(
//           message: "Login failed",
//           requestOptions: RequestOptions(path: '/login'),
//         ),
//       );

//       // Act & Assert
//       await expectLater(
//         authRepository.logIn(
//           AuthMocks.getMockEmail,
//           AuthMocks.getMockPassword,
//         ),
//         throwsA(isA<Failure>()),
//       );
//       verify(() => mockIsarService.getLoggedInUser()).called(1);
//       verify(() => mockApiService.logIn(
//             AuthMocks.getMockEmail,
//             AuthMocks.getMockPassword,
//           )).called(1);
//     });

//     test(
//         'should throw Failure if IsarService.getLoggedInUser throws an exception',
//         () async {
//       // Arrange
//       when(() => mockIsarService.getLoggedInUser()).thenThrow(DioException(
//         message: "Database error",
//         requestOptions: RequestOptions(path: '/isar'),
//       ));

//       // Act & Assert
//       await expectLater(
//         authRepository.logIn(
//           AuthMocks.getMockEmail,
//           AuthMocks.getMockPassword,
//         ),
//         throwsA(isA<Failure>()),
//       );
//       verify(() => mockIsarService.getLoggedInUser()).called(1);
//       verifyNever(() => mockApiService.logIn(
//             AuthMocks.getMockEmail,
//             AuthMocks.getMockPassword,
//           ));
//     });

//     test('should throw Failure if IsarService.saveUser throws an exception',
//         () async {
//       // Arrange
//       when(() => mockIsarService.getLoggedInUser())
//           .thenAnswer((_) async => null);
//       when(() => mockApiService.logIn(
//             AuthMocks.getMockEmail,
//             AuthMocks.getMockPassword,
//           )).thenAnswer((_) async => AuthMocks.getMockCurrentUser);
//       when(() => mockIsarService.saveUser(any())).thenThrow(DioException(
//         message: "Save user failed",
//         requestOptions: RequestOptions(path: '/save-user'),
//       ));

//       // Act & Assert
//       await expectLater(
//         authRepository.logIn(
//           AuthMocks.getMockEmail,
//           AuthMocks.getMockPassword,
//         ),
//         throwsA(isA<Failure>()),
//       );
//       verify(() => mockIsarService.getLoggedInUser()).called(2);
//     });
//   });
// }
