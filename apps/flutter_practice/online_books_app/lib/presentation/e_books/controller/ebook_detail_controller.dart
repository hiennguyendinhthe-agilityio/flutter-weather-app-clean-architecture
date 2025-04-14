import 'package:get/get.dart';
import 'package:online_books_app/presentation/e_books/models/books_model.dart';
import 'package:online_books_app/presentation/e_books/service/ebook_service.dart';

class EBookDetailController extends GetxController {
  var isLoading = true.obs;
  var currentBook = Rxn<Books>();
  var errorMessage = Rxn<String>();

  final EbookService _ebookService = Get.find<EbookService>();

  @override
  void onReady() {
    super.onReady();
    _initializeAndFetch();
  }

  void _initializeAndFetch() {
    final Map<String, dynamic>? arguments =
        Get.arguments as Map<String, dynamic>?;

    final Books? initialData = arguments?['book'] as Books?;

    final String? bookId = arguments?['id'] as String?;

    fetchBookDetails(bookId, initialData);
  }

  Future<void> fetchBookDetails(String? bookId, Books? initialData) async {
    isLoading.value = true;
    errorMessage.value = null;
    currentBook.value = null;

    if (initialData != null) {
      print("EBookDetailController: Using initial book data provided.");
      currentBook.value = initialData;
      isLoading.value = false;
      return;
    }

    if (bookId != null) {
      print("EBookDetailController: Fetching book details for ID: $bookId");
      try {
        final fetchedBook = await _ebookService.getBookById(bookId);
        if (fetchedBook != null) {
          print("EBookDetailController: Book data fetched successfully.");
          currentBook.value = fetchedBook;
        } else {
          throw 'Book with ID $bookId not found from service.';
        }
      } catch (e) {
        print("EBookDetailController: Error fetching book details: $e");
        errorMessage.value = "Failed to load book details.";
      } finally {
        isLoading.value = false;
      }
    } else {
      print(
          "EBookDetailController: Error - No book ID or initial data provided.");
      errorMessage.value = "Book ID or data is missing.";
      isLoading.value = false;
    }
  }
}
