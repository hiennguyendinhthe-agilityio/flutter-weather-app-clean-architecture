import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_books_app/presentation/e_books/controller/author_controller.dart';
import 'package:online_books_app/presentation/e_books/models/books_model.dart';

import '../../mock/mock_ebook_service.dart';

void main() {
  late AuthorBooksController controller;
  late MockEbookService mockEbookService;

  setUp(() {
    mockEbookService = MockEbookService();
    controller = AuthorBooksController(ebookService: mockEbookService);
  });

  group('fetchBooks', () {
    test('should update authors list when fetch is successful', () async {
      // Arrange
      final mockBooks = [
        Books(
          id: '1',
          fullName: 'Test Author 1',
          occupation: 'Writer',
          biography: 'Test Biography 1',
          avatarUrl: 'test_url_1',
          starRating: 5,
          pdfUrl: 'test_pdf_1',
        ),
        Books(
          id: '2',
          fullName: 'Test Author 2',
          occupation: 'Poet',
          biography: 'Test Biography 2',
          avatarUrl: 'test_url_2',
          starRating: 4,
          pdfUrl: 'test_pdf_2',
        ),
      ];

      when(() => mockEbookService.getBooks())
          .thenAnswer((_) async => mockBooks);

      // Act
      await controller.fetchBooks();

      // Assert
      expect(controller.authors.length, equals(2));
      expect(controller.authors[0].id, equals('1'));
      expect(controller.authors[1].id, equals('2'));
      expect(controller.isLoading.value, isFalse);
      verify(() => mockEbookService.getBooks()).called(1);
    });

    test('should handle error when fetch fails', () async {
      // Arrange
      when(() => mockEbookService.getBooks())
          .thenThrow(Exception('Failed to fetch books'));

      // Act
      await controller.fetchBooks();

      // Assert
      expect(controller.authors.isEmpty, isTrue);
      expect(controller.isLoading.value, isFalse);
      verify(() => mockEbookService.getBooks()).called(1);
    });
  });

  group('getBookById', () {
    test('should return book when found', () {
      // Arrange
      final mockBook = Books(
        id: '1',
        fullName: 'Test Author',
        occupation: 'Writer',
        biography: 'Test Biography',
        avatarUrl: 'test_url',
        starRating: 5,
        pdfUrl: 'test_pdf',
      );
      controller.authors.add(mockBook);

      // Act
      final result = controller.getBookById('1');

      // Assert
      expect(result, equals(mockBook));
    });

    test('should return null when book not found', () {
      // Act
      final result = controller.getBookById('non_existent_id');

      // Assert
      expect(result, isNull);
    });
  });
}
