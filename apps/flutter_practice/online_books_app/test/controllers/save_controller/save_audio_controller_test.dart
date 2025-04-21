import 'package:flutter_test/flutter_test.dart';
import 'package:online_books_app/presentation/saved/controller/saved_controller.dart';

import '../../mock_data.dart';

void main() {
  late SavedAudioBooksController savedAudioBooksController;

  setUp(() {
    savedAudioBooksController = SavedAudioBooksController();
  });

  group('SavedAudioBooksController Tests', () {
    test('addAudioBookToSaved adds an audio book to the savedAudioBooks list',
        () {
      final audioBook = MockData.generateFakeAudioBook();

      savedAudioBooksController.addAudioBookToSaved(audioBook);

      expect(savedAudioBooksController.savedAudioBooks.length, 1);
      expect(savedAudioBooksController.savedAudioBooks.first.fullName,
          audioBook.fullName);
    });

    test(
        'removeAudioBookFromSaved removes an audio book from the savedAudioBooks list',
        () {
      final audioBook = MockData.generateFakeAudioBook();
      savedAudioBooksController.addAudioBookToSaved(audioBook);

      expect(savedAudioBooksController.savedAudioBooks.length, 1);

      savedAudioBooksController.removeAudioBookFromSaved(audioBook);

      expect(savedAudioBooksController.savedAudioBooks.isEmpty, true);
    });

    test(
        'addAudioBookToSaved does not add duplicates to the savedAudioBooks list',
        () {
      final audioBook = MockData.generateFakeAudioBook();

      savedAudioBooksController.addAudioBookToSaved(audioBook);
      savedAudioBooksController.addAudioBookToSaved(audioBook);

      expect(savedAudioBooksController.savedAudioBooks.length, 2);
    });

    test('adding and removing audio books works as expected', () {
      final audioBook1 = MockData.generateFakeAudioBook();
      final audioBook2 = MockData.generateFakeAudioBook();

      savedAudioBooksController.addAudioBookToSaved(audioBook1);
      savedAudioBooksController.addAudioBookToSaved(audioBook2);

      expect(savedAudioBooksController.savedAudioBooks.length, 2);

      savedAudioBooksController.removeAudioBookFromSaved(audioBook1);

      expect(savedAudioBooksController.savedAudioBooks.length, 1);
      expect(savedAudioBooksController.savedAudioBooks.first.fullName,
          audioBook2.fullName);
    });
  });
}
