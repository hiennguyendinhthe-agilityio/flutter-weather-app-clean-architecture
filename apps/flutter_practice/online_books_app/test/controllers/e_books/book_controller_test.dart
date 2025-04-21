import 'package:flutter_test/flutter_test.dart';
import 'package:online_books_app/presentation/e_books/controller/book_controller.dart';

void main() {
  late BookController controller;

  setUp(() {
    controller = BookController();
  });

  group('setBookData', () {
    test('should set all book data correctly', () {
      // Arrange
      const title = 'Test Book';
      const description = 'Test Description';
      const author = 'Test Author';
      const imagePath = 'test_image.jpg';
      const starRating = 5;
      const pdfUrl = 'test.pdf';

      // Act
      controller.setBookData(
        title: title,
        description: description,
        author: author,
        imagePath: imagePath,
        starRating: starRating,
        pdfUrl: pdfUrl,
      );

      // Assert
      expect(controller.bookTitle.value, equals(title));
      expect(controller.bookDescription.value, equals(description));
      expect(controller.bookAuthor.value, equals(author));
      expect(controller.bookImagePath.value, equals(imagePath));
      expect(controller.start.value, equals(starRating));
      expect(controller.bookContent.value, equals(pdfUrl));
    });

    test('should handle empty values', () {
      // Act
      controller.setBookData(
        title: '',
        description: '',
        author: '',
        imagePath: '',
        starRating: 0,
        pdfUrl: '',
      );

      // Assert
      expect(controller.bookTitle.value, equals(''));
      expect(controller.bookDescription.value, equals(''));
      expect(controller.bookAuthor.value, equals(''));
      expect(controller.bookImagePath.value, equals(''));
      expect(controller.start.value, equals(0));
      expect(controller.bookContent.value, equals(''));
    });

    test('should update existing values', () {
      // Arrange - Set initial values
      controller.setBookData(
        title: 'Initial Title',
        description: 'Initial Description',
        author: 'Initial Author',
        imagePath: 'initial_image.jpg',
        starRating: 3,
        pdfUrl: 'initial.pdf',
      );

      // Act - Update with new values
      controller.setBookData(
        title: 'Updated Title',
        description: 'Updated Description',
        author: 'Updated Author',
        imagePath: 'updated_image.jpg',
        starRating: 4,
        pdfUrl: 'updated.pdf',
      );

      // Assert
      expect(controller.bookTitle.value, equals('Updated Title'));
      expect(controller.bookDescription.value, equals('Updated Description'));
      expect(controller.bookAuthor.value, equals('Updated Author'));
      expect(controller.bookImagePath.value, equals('updated_image.jpg'));
      expect(controller.start.value, equals(4));
      expect(controller.bookContent.value, equals('updated.pdf'));
    });
  });
}
