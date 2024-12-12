import 'package:bazar_books_design/core/core.dart';

abstract class AuthorRepository {
  Future<List<Author>> fetchAuthors();

  Future<Author> fetchAuthorProfile(String productId);
}
