import 'package:faker/faker.dart';
import 'package:online_books_app/presentation/audio_books/model/audio_books_model.dart';
import 'package:online_books_app/presentation/e_books/models/books_model.dart';

class MockData {
  static final Faker faker = Faker();

  static Books generateFakeBook() {
    return Books(
      id: faker.guid.guid(),
      fullName: faker.person.name(),
      occupation: faker.job.title(),
      biography: faker.lorem.sentence(),
      avatarUrl: faker.image.image(),
      starRating: faker.randomGenerator.integer(5, min: 1),
      pdfUrl: faker.internet.httpUrl(),
    );
  }

  static List<Books> generateFakeBooks(int count) {
    List<Books> books = [];
    for (int i = 0; i < count; i++) {
      books.add(generateFakeBook());
    }
    return books;
  }

  static AudioBooks generateFakeAudioBook() {
    return AudioBooks(
      id: faker.guid.guid(),
      fullName: faker.person.name(),
      occupation: faker.job.title(),
      biography: faker.lorem.sentence(),
      avatarUrl: faker.image.loremPicsum(),
      starRating: faker.randomGenerator.integer(5, min: 1),
      duration: '${faker.randomGenerator.integer(120, min: 30)} min',
    );
  }

  static List<AudioBooks> generateFakeAudioBooks(int count) {
    List<AudioBooks> audioBooks = [];
    for (int i = 0; i < count; i++) {
      audioBooks.add(generateFakeAudioBook());
    }
    return audioBooks;
  }
}
