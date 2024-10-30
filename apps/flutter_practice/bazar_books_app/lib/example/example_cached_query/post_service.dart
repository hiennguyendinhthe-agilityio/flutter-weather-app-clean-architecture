import 'package:dio/dio.dart';

class PostService {
  Future<List<dynamic>> getPosts({
    required int page,
    required int limit,
  }) async {
    final uri = Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_page=$page&_limit=$limit');
    final response = await Dio().get(
      uri.toString(),
    );
    return Future.delayed(const Duration(seconds: 1), () {
      return response.data;
    });
  }
}
