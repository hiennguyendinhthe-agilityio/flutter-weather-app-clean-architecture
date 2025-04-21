import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_books_app/presentation/e_books/controller/ebook_detail_controller.dart';
import 'package:online_books_app/presentation/e_books/models/books_model.dart';
import 'package:online_books_app/presentation/e_books/service/ebook_service.dart';

import '../../mock/mock_ebook_service.dart';

void main() {
  late EBookDetailController controller;
  late MockEbookService mockEbookService;

  setUp(() {
    mockEbookService = MockEbookService();
    Get.put<EbookService>(mockEbookService);
    controller = EBookDetailController();
  });

  tearDown(() {
    Get.reset();
  });

  group('fetchBookDetails', () {
    test('should use initial data when provided', () async {
      // Arrange
      final mockBook = Books(
        id: '1',
        fullName: 'Test Book',
        occupation: 'Author',
        biography: 'Test Description',
        avatarUrl: 'test.jpg',
        starRating: 5,
        pdfUrl: 'test.pdf',
      );

      // Act
      await controller.fetchBookDetails(null, mockBook);

      // Assert
      expect(controller.isLoading.value, false);
      expect(controller.currentBook.value, mockBook);
      expect(controller.errorMessage.value, null);
      verifyNever(() => mockEbookService.getBookById(any()));
    });

    test('should fetch book details when bookId is provided', () async {
      // Arrange
      const bookId = '1';
      final mockBook = Books(
        id: bookId,
        fullName: 'Test Book',
        occupation: 'Author',
        biography: 'Test Description',
        avatarUrl: 'test.jpg',
        starRating: 5,
        pdfUrl: 'test.pdf',
      );

      when(() => mockEbookService.getBookById(bookId))
          .thenAnswer((_) async => mockBook);

      // Act
      await controller.fetchBookDetails(bookId, null);

      // Assert
      expect(controller.isLoading.value, false);
      expect(controller.currentBook.value, mockBook);
      expect(controller.errorMessage.value, null);
      verify(() => mockEbookService.getBookById(bookId)).called(1);
    });

    test('should set error message when service returns null', () async {
      // Arrange
      const bookId = '1';
      when(() => mockEbookService.getBookById(bookId))
          .thenAnswer((_) async => null);

      // Act
      await controller.fetchBookDetails(bookId, null);

      // Assert
      expect(controller.isLoading.value, false);
      expect(controller.currentBook.value, null);
      expect(controller.errorMessage.value, 'Failed to load book details.');
      verify(() => mockEbookService.getBookById(bookId)).called(1);
    });

    test(
        'should set error message when neither bookId nor initialData is provided',
        () async {
      // Act
      await controller.fetchBookDetails(null, null);

      // Assert
      expect(controller.isLoading.value, false);
      expect(controller.currentBook.value, null);
      expect(controller.errorMessage.value, 'Book ID or data is missing.');
      verifyNever(() => mockEbookService.getBookById(any()));
    });

    test('should handle service errors gracefully', () async {
      // Arrange
      const bookId = '1';
      when(() => mockEbookService.getBookById(bookId))
          .thenThrow(Exception('Service error'));

      // Act
      await controller.fetchBookDetails(bookId, null);

      // Assert
      expect(controller.isLoading.value, false);
      expect(controller.currentBook.value, null);
      expect(controller.errorMessage.value, 'Failed to load book details.');
      verify(() => mockEbookService.getBookById(bookId)).called(1);
    });
  });
}
