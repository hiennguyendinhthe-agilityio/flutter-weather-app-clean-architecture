import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_books_app/presentation/e_books/controller/ebook_detail_controller.dart';
import 'package:online_books_app/presentation/e_books/models/books_model.dart';
import 'package:online_books_app/presentation/e_books/service/ebook_service.dart';

class MockEbookService extends Mock implements EbookService {}

void main() {
  late EBookDetailController controller;
  late MockEbookService mockEbookService;
  setUpAll(() {
    Get.testMode = true; // Enable GetX test mode
  });
  setUp(() {
    mockEbookService = MockEbookService();
    Get.reset(); // Reset GetX before each test
    Get.lazyPut<EbookService>(
        () => mockEbookService); // Use lazyPut instead of put
    controller = EBookDetailController();
  });

  tearDown(() {
    Get.reset();
  });

  group('EBookDetailController Tests', () {
    final mockBook = Books(
      id: '1',
      fullName: 'Test Book',
      occupation: 'Test Author',
      biography: 'Test Description',
    );

    test('fetchBookDetails with initial data should set current book',
        () async {
      // Act
      await controller.fetchBookDetails(null, mockBook);

      // Assert
      expect(controller.currentBook.value, equals(mockBook));
      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, null);
      verifyNever(() => mockEbookService.getBookById(any()));
    });

    test('fetchBookDetails with valid bookId should fetch book data', () async {
      // Arrange
      when(() => mockEbookService.getBookById('1'))
          .thenAnswer((_) async => mockBook);

      // Act
      await controller.fetchBookDetails('1', null);

      // Assert
      expect(controller.currentBook.value, equals(mockBook));
      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, null);
      verify(() => mockEbookService.getBookById('1')).called(1);
    });

    test('fetchBookDetails with non-existent bookId should set error',
        () async {
      // Arrange
      when(() => mockEbookService.getBookById('999'))
          .thenAnswer((_) async => null);

      // Act
      await controller.fetchBookDetails('999', null);

      // Assert
      expect(controller.currentBook.value, null);
      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, 'Failed to load book details.');
      verify(() => mockEbookService.getBookById('999')).called(1);
    });

    test('fetchBookDetails with service error should handle exception',
        () async {
      // Arrange
      when(() => mockEbookService.getBookById(any()))
          .thenThrow(Exception('Network error'));

      // Act
      await controller.fetchBookDetails('1', null);

      // Assert
      expect(controller.currentBook.value, null);
      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, 'Failed to load book details.');
      verify(() => mockEbookService.getBookById('1')).called(1);
    });

    test(
        'fetchBookDetails with null bookId and no initial data should set error',
        () async {
      // Act
      await controller.fetchBookDetails(null, null);

      // Assert
      expect(controller.currentBook.value, null);
      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, 'Book ID or data is missing.');
      verifyNever(() => mockEbookService.getBookById(any()));
    });
  });
}
