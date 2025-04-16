import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  final BookController _bookController = Get.put(BookController());

  @override
  void initState() {
    super.initState();
    initDeepLinks();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle app start from deep link
    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null) {
      _handleDeepLink(appLink);
    }

    // Handle app opened from deep link
    _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  // Update the _handleDeepLink method to use the parser
  void _handleDeepLink(Uri uri) {
    print('Deep link received: $uri');

    final bookId = DeepLinkParser.extractBookId(uri);

    if (DeepLinkParser.isValidBookId(bookId)) {
      print('Valid book ID extracted: $bookId');
      // Ensure books are loaded before navigating
      _bookController.ensureBooksLoaded().then((_) {
        Get.toNamed(Routes.BOOK_DETAILS, arguments: bookId);
      });
    } else {
      print('No valid book ID found in deep link: $uri');
      Get.snackbar(
        'Invalid Link',
        'The link you followed does not contain a valid book reference.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Book App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Routes.HOME,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Routes {
  static const String HOME = '/';
  static const String BOOK_DETAILS = '/book';
  static const String SEARCH = '/search';
}

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
    ),
    GetPage(
      name: Routes.BOOK_DETAILS,
      page: () => BookDetailsPage(),
    ),
    GetPage(
      name: Routes.SEARCH,
      page: () => SearchPage(),
    ),
  ];
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final BookController bookController = Get.find<BookController>();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Reset search results when page opens
    bookController.filteredBooks.value = bookController.books;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search books...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            bookController.searchBooks(value);
          },
          autofocus: true,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
              bookController.searchBooks('');
            },
          ),
        ],
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: bookController.filteredBooks.length,
          itemBuilder: (context, index) {
            final book = bookController.filteredBooks[index];
            return ListTile(
              title: Text(book.title),
              subtitle: Text(book.author),
              onTap: () => Get.toNamed(
                Routes.BOOK_DETAILS,
                arguments: book.id,
              ),
            );
          },
        );
      }),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class HomePage extends StatelessWidget {
  final BookController bookController = Get.find<BookController>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Get.toNamed(Routes.SEARCH),
          ),
        ],
      ),
      body: Obx(() {
        if (bookController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: bookController.books.length,
          itemBuilder: (context, index) {
            final book = bookController.books[index];
            return ListTile(
              title: Text(book.title),
              subtitle: Text(book.author),
              onTap: () => Get.toNamed(
                Routes.BOOK_DETAILS,
                arguments: book.id,
              ),
            );
          },
        );
      }),
    );
  }
}

class BookDetailsPage extends StatelessWidget {
  final BookController bookController = Get.find<BookController>();

  BookDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String bookId = Get.arguments as String;

    return Obx(() {
      if (bookController.isLoading.value) {
        return Scaffold(
          appBar: AppBar(title: Text('Loading...')),
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final Book? book = bookController.getBookById(bookId);

      if (book == null) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Book Not Found'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Get.offAllNamed(Routes.HOME),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade300,
                ),
                SizedBox(height: 16),
                Text(
                  'Book Not Found',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'The book with ID "$bookId" could not be found.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.offAllNamed(Routes.HOME),
                  child: Text('Go to Home'),
                ),
              ],
            ),
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: Text('Book Details'),
          actions: [
            // Update the share functionality to use the parser
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                // Share deep link to this book using the parser
                Share.share(
                  DeepLinkParser.createBookShareLink(book.id),
                  subject: 'Check out this book: ${book.title}',
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'By ${book.author}',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 16),
              Text(
                book.description,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class Book {
  final String id;
  final String title;
  final String author;
  final String description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
  });
}

class BookController extends GetxController {
  var books = <Book>[].obs;
  var filteredBooks = <Book>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  // Add a method to ensure books are loaded before accessing them
  Future<void> ensureBooksLoaded() async {
    if (books.isEmpty) {
      await fetchBooks();
    }
  }

  // Modify fetchBooks to return a Future
  Future<void> fetchBooks() async {
    if (isLoading.value) return;

    try {
      isLoading(true);
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      // Sample data
      final sampleBooks = [
        Book(
          id: '1',
          title: 'Flutter in Action',
          author: 'Eric Windmill',
          description: 'A comprehensive guide to Flutter development',
        ),
        Book(
          id: '2',
          title: 'Dart Apprentice',
          author: 'Jonathan Sande',
          description: 'Beginning programming with Dart',
        ),
        Book(
          id: '3',
          title: 'Flutter Cookbook',
          author: 'Simone Alessandria',
          description:
              'Practical recipes for building cross-platform applications',
        ),
      ];

      books.value = sampleBooks;
      filteredBooks.value = sampleBooks;
    } finally {
      isLoading(false);
    }
  }

  Book? getBookById(String id) {
    try {
      return books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }

  void searchBooks(String query) {
    if (query.isEmpty) {
      filteredBooks.value = books;
    } else {
      filteredBooks.value = books
          .where((book) =>
              book.title.toLowerCase().contains(query.toLowerCase()) ||
              book.author.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}

class DeepLinkParser {
  /// Extracts a book ID from a deep link URI
  static String? extractBookId(Uri uri) {
    try {
      // Handle web links (https://online-books-app.web.app/share/...)
      if (uri.host == 'online-books-app.web.app' &&
          uri.path.startsWith('/share')) {
        return uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
      }
      // Handle custom scheme (yourapp://book/...)
      else if (uri.scheme == 'yourapp' && uri.host == 'book') {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
      }

      return null;
    } catch (e) {
      debugPrint('Error parsing deep link: $e');
      return null;
    }
  }

  /// Validates if a book ID is in the correct format
  static bool isValidBookId(String? bookId) {
    if (bookId == null || bookId.isEmpty) {
      return false;
    }

    // Add any additional validation logic here
    // For example, if book IDs should be numeric:
    // return int.tryParse(bookId) != null;

    return true;
  }

  /// Creates a shareable deep link for a book
  static String createBookShareLink(String bookId) {
    return 'https://online-books-app.web.app/share/$bookId';
  }
}
