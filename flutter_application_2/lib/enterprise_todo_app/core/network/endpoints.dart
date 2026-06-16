class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  static const String todos = '/todos';
  static String todoById(int id) => '/todos/$id';

  static const String users = '/users';
  static String userById(int id) => '/users/$id';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 15);
}
