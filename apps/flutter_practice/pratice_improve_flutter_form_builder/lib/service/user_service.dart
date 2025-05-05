import 'package:dio/dio.dart';
import 'package:pratice_improve_flutter_form_builder/data/constants/constants.dart';
import 'package:pratice_improve_flutter_form_builder/data/models/auth_model/api_user.dart';
import 'package:pratice_improve_flutter_form_builder/service/auth_storage_service.dart';

class UserService {
  final Dio _dio = Dio();

  Future<ApiUser> fetchUserData() async {
    final credentials = await AuthStorageService().getSavedCredentials();
    final email = credentials['email'];

    final response = await _dio.get('${Constants.apiUrlUser}user');

    if (response.statusCode == 200) {
      final List users = response.data;

      final userJson = users.firstWhere(
        (u) => u['email'] == email,
        orElse: () => null,
      );

      if (userJson != null) {
        return ApiUser.fromJson(userJson);
      } else {
        throw Exception('User not found');
      }
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
