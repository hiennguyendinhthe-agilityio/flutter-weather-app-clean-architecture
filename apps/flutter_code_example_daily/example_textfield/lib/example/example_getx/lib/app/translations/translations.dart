import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'home': 'Home',
          'second': 'Second Screen',
          'settings': 'Settings',
          'switch_theme': 'Switch Theme',
          'change_language': 'Change Language',
          'language': 'Language',
        },
        'vi_VN': {
          'home': 'Trang chủ',
          'second': 'Màn hình thứ hai',
          'settings': 'Cài đặt',
          'switch_theme': 'Đổi giao diện',
          'change_language': 'Đổi ngôn ngữ',
          'language': 'Ngôn ngữ',
        },
      };
}
