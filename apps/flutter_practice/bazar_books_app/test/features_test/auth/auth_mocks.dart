import 'dart:math';

import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:bazar_books_design/core/apis/api_service.dart';
import 'package:bazar_books_design/core/models/auth_model/api_user.dart';
import 'package:bazar_books_design/core/network/error_handler.dart';
import 'package:bazar_books_design/core/network/failure.dart';
import 'package:bazar_books_design/db/isar_service.dart';
import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

// Service Mocks
class MockApiService extends Mock implements ApiService {}

class MockIsarService extends Mock implements IsarService {}

// Mocking AuthRepository
class MockAuthRepositoryImpl extends Mock implements AuthRepositoryImpl {}

class FakeUser extends Fake implements ApiUser {}

// Data Mocks
class AuthMocks {
// Function to generate a mock user with random data
  static final getMockCurrentUser = ApiUser(
    userId: faker.guid.guid(),
    email: faker.internet.email(),
    password: faker.internet.password(),
    isLoggedIn: true,
  );

  static final dioExceptionMock = DioException(
    requestOptions: RequestOptions(),
    response: Response(
      statusMessage: faker.lorem.sentence(),
      data: Failure(
        409,
        message: 'Email already exists, please check again!',
      ),
      statusCode: 409,
      requestOptions: RequestOptions(),
    ),
  );

  static final getMockName = faker.person.name();

  static final getMockEmail = faker.internet.email();

  static final getMockPassword = faker.internet.password();

  static final getMockIloggedIn = faker.randomGenerator.boolean();

  static final getMockUserId = faker.guid.guid();

  static final getMockUser = ApiUser(
    userId: faker.guid.guid(),
    email: faker.internet.email(),
    password: faker.internet.password(),
  );

  static final failureMock = Exception(faker.lorem.sentence());

  static const getMockEmpty = '';

  static final failureMockMessage = ErrorHandler.handle(e).failure.message;

  static final mockDioError = DioException(
    requestOptions: RequestOptions(),
    response: Response(
      statusCode: 404,
      statusMessage: 'Not Found',
      requestOptions: RequestOptions(),
    ),
  );
}
