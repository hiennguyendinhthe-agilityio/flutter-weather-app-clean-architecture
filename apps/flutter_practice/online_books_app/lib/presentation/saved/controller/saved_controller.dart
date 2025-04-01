import 'package:online_books_app/core/app_export.dart';
import 'package:online_books_app/presentation/audio_books/model/audio_books_model.dart';
import 'package:online_books_app/presentation/e_books/models/books_model.dart';

class SavedBooksController extends GetxController {
  SavedBooksController();

  // Rx<SavedModel> savedModelObj;
  var savedBooks = <Books>[].obs;

  void addBookToSaved(Books book) {
    savedBooks.add(book);
  }

  void removeBookFromSaved(Books book) {
    savedBooks.remove(book);
  }
}

class SavedAudioBooksController extends GetxController {
  SavedAudioBooksController();

  var savedAudioBooks = <AudioBooks>[].obs;

  void addAudioBookToSaved(AudioBooks audioBook) {
    savedAudioBooks.add(audioBook);
  }

  void removeAudioBookFromSaved(AudioBooks audioBook) {
    savedAudioBooks.remove(audioBook);
  }
}
