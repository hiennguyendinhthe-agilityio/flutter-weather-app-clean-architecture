import 'package:bazar_books_design/bazar_books_design.dart';

import 'author_repository.dart';

class AuthorRepositoryImpl implements AuthorRepository {
  final ApiService apiService;
  final ProductService productRepository;

  AuthorRepositoryImpl(this.apiService, this.productRepository);

  // Fetch vendors using the ApiService

  @override
  Future<List<Author>> fetchAuthors() async {
    try {
      // Call the appropriate method from ApiService to fetch vendors
      final authors = await apiService.getAuthors();
      return authors;
    } catch (e) {
      // Handle errors appropriately, maybe print them or rethrow with a custom exception
      throw ErrorHandler.handle(e).failure;
    }
  }

  @override
  Future<Author> fetchAuthorProfile(String productId) async {
    try {
      // Call the appropriate method from ApiService to fetch authors
      final authors = await apiService.fetchAuthorProfile(productId);
      return authors;
    } catch (e) {
      // Handle errors appropriately, maybe print them or rethrow with a custom exception
      throw ErrorHandler.handle(e).failure;
    }
  }
}
