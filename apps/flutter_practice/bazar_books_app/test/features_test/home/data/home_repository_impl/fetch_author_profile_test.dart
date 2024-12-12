import 'package:bazar_books_app/features/home/data/author_repository/author_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../home_mocks.dart';

void main() {
  late MockHomeApiService mockHomeApiService;
  late AuthorRepositoryImpl homeRepository;

  setUp(() {
    mockHomeApiService = MockHomeApiService();
    homeRepository =
        AuthorRepositoryImpl(mockHomeApiService, MockProductService());
  });

  group('fetchAuthorProfile', () {
    test('returns Author Profile on successful fetch', () async {
      // Arrange

      when(() => mockHomeApiService.fetchAuthorProfile(HomeMocks.mockAuthorId))
          .thenAnswer((_) async => HomeMocks.mockAuthor);

      // Act
      final result =
          await homeRepository.fetchAuthorProfile(HomeMocks.mockAuthorId);

      // Assert
      expect(result, HomeMocks.mockAuthor);
      verify(() =>
              mockHomeApiService.fetchAuthorProfile(HomeMocks.mockAuthorId))
          .called(1);
    });
  });
}
