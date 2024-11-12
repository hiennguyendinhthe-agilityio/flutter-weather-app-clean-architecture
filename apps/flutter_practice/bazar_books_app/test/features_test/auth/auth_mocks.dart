import 'package:bazar_books_design/core/apis/api_service.dart';
import 'package:bazar_books_design/core/models/auth_model/user.dart';
import 'package:bazar_books_design/db/isar_service.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

// Service Mocks
class MockApiService extends Mock implements ApiService {}

class MockIsarService extends Mock implements IsarService {}

// Data Mocks
class AuthMocks {
// Function to generate a mock user with random data
  static final getMockCurrentUser = User(
    userId: faker.guid.guid(),
    email: faker.internet.email(),
    password: faker.internet.password(),
    isLoggedIn: true,
  );

  static final getMockName = faker.person.name();

  static final getMockEmail = faker.internet.email();

  static final getMockPassword = faker.internet.password();

  static final getMockIloggedIn = faker.randomGenerator.boolean();

  static final getMockUserId = faker.guid.guid();

  static final getMockUser = User(
    userId: faker.guid.guid(),
    email: faker.internet.email(),
    password: faker.internet.password(),
    isLoggedIn: false,
  );

  static final failureMock = Exception(faker.lorem.sentence());
}
