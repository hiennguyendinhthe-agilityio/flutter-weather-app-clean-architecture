// import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// import '../../auth_mocks.dart';

// void main() {
//   late AuthBloc authBloc;
//   late MockAuthRepositoryImpl mockAuthRepository;

//   setUp(() {
//     mockAuthRepository = MockAuthRepositoryImpl();
//     authBloc = AuthBloc(mockAuthRepository);
//   });

//   tearDown(() {
//     authBloc.close();
//   });

//   group('IsLoggedIn', () {
//     blocTest<AuthBloc, AuthState>(
//       'emits [AuthenticationLoading, Authenticated] when user is logged in',
//       setUp: () {
//         when(() => mockAuthRepository.isLoggedIn())
//             .thenAnswer((_) async => true);
//         when(() => mockAuthRepository.getCurrentUser())
//             .thenAnswer((_) async => AuthMocks.getMockCurrentUserApi);
//       },
//       build: () => authBloc,
//       act: (bloc) => bloc.add(IsLoggedIn()),
//       expect: () => [
//         AuthenticationLoading(),
//         Authenticated(AuthMocks.getMockCurrentUserApi)
//       ],
//     );
//     blocTest<AuthBloc, AuthState>(
//       'emits [AuthenticationLoading, Unauthenticated] when logged is added',
//       setUp: () {
//         when(() => mockAuthRepository.isLoggedIn()).thenAnswer((_) async {
//           return false;
//         });
//       },
//       build: () => authBloc,
//       act: (bloc) => bloc.add(IsLoggedIn()),
//       expect: () => [AuthenticationLoading(), Unauthenticated()],
//     );

//     blocTest<AuthBloc, AuthState>(
//       'emits [AuthenticationLoading, Unauthenticated] when user is not logged in',
//       setUp: () {
//         when(() => mockAuthRepository.isLoggedIn())
//             .thenAnswer((_) async => false);
//       },
//       build: () => authBloc,
//       act: (bloc) => bloc.add(IsLoggedIn()),
//       expect: () => [AuthenticationLoading(), Unauthenticated()],
//     );
//   });
// }
