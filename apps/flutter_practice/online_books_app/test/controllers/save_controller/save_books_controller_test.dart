import 'package:flutter_test/flutter_test.dart';
import 'package:online_books_app/presentation/saved/controller/saved_controller.dart';

import '../../mock_data.dart';

void main() {
  late SavedBooksController savedBooksController;

  setUp(() {
    savedBooksController = SavedBooksController();
  });

  group('SavedBooksController Tests', () {
    test('addBookToSaved adds a book to the savedBooks list', () {
      final book = MockData.generateFakeBook();

      savedBooksController.addBookToSaved(book);

      expect(savedBooksController.savedBooks.length, 1);
      expect(savedBooksController.savedBooks.first.fullName, book.fullName);
    });

    test('removeBookFromSaved removes a book from the savedBooks list', () {
      final book = MockData.generateFakeBook();
      savedBooksController.addBookToSaved(book);

      expect(savedBooksController.savedBooks.length, 1);

      savedBooksController.removeBookFromSaved(book);

      expect(savedBooksController.savedBooks.isEmpty, true);
    });

    test('addBookToSaved does not add duplicates to the savedBooks list', () {
      final book = MockData.generateFakeBook();

      savedBooksController.addBookToSaved(book);
      savedBooksController.addBookToSaved(book);

      expect(savedBooksController.savedBooks.length, 2);
    });

    test('adding and removing books works as expected', () {
      final book1 = MockData.generateFakeBook();
      final book2 = MockData.generateFakeBook();

      savedBooksController.addBookToSaved(book1);
      savedBooksController.addBookToSaved(book2);

      expect(savedBooksController.savedBooks.length, 2);

      savedBooksController.removeBookFromSaved(book1);

      expect(savedBooksController.savedBooks.length, 1);
      expect(savedBooksController.savedBooks.first.fullName, book2.fullName);
    });
  });
}
