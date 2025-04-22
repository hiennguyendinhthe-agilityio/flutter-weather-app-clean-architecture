import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          // General
          'app_title': 'Multi-Step Form',

          // Common UI elements
          'go_back': 'Go back',
          'continue': 'Continue',
          'lets_create': 'Let\'s create!',
          'step_indicator': 'Step %s of %s',

          // App header
          'lets_work_together': 'Let\'s work together',
          'agency_description':
              'We\'re a full-service agency dedicated to helping you go from MVP to industry leader. Let our team bring your goals to life.',

          // Screen One - Form fields
          'full_name': 'Full name*',
          'first_name_hint': 'First name',
          'last_name': 'Last name*',
          'last_name_hint': 'Last name',
          'email': 'Email*',
          'email_hint': 'Email address',
          'website': 'Website',
          'website_hint': 'Website',
          'phone_number': 'Phone number',
          'phone_hint': '(555) 000-0000',
          'help_description': 'How can we help?',
          'help_hint':
              'A brief summary of what you need help with, expected timelines, preferred communication method, etc.',

          // Screen Two - Form fields
          'team_size': 'Team size*',
          'team_size_format': '%s-%s people',
          'budget': 'Budget*',
          'budget_format': '\$%s - \$%s USD',
          'need_help_with': 'What do you need help with?*',

          // Service options
          'web_design': 'Web Design',
          'ui_ux_design': 'UI/UX Design',
          'app_design': 'App Design',
          'development': 'Development',
          'technical_seo': 'Technical SEO',
          'content_writing': 'Content Writing',
          'strategy': 'Strategy',
          'research': 'Research',
          'other': 'Other',
        },
        // Thêm các ngôn ngữ khác ở đây, ví dụ:
        'vi_VN': {
          // General
          'app_title': 'Biểu mẫu nhiều bước',

          // Common UI elements
          'go_back': 'Quay lại',
          'continue': 'Tiếp tục',
          'lets_create': 'Hãy tạo!',
          'step_indicator': 'Bước %s / %s',

          // App header
          'lets_work_together': 'Hãy làm việc cùng nhau',
          'agency_description':
              'Chúng tôi là một đại lý dịch vụ toàn diện giúp bạn từ MVP đến dẫn đầu ngành. Hãy để đội ngũ chúng tôi hiện thực hóa mục tiêu của bạn.',

          // Screen One - Form fields
          'full_name': 'Họ và tên*',
          'first_name_hint': 'Tên',
          'last_name': 'Họ*',
          'last_name_hint': 'Họ',
          'email': 'Email*',
          'email_hint': 'Địa chỉ email',
          'website': 'Website',
          'website_hint': 'Website',
          'phone_number': 'Số điện thoại',
          'phone_hint': '(555) 000-0000',
          'help_description': 'Chúng tôi có thể giúp gì?',
          'help_hint':
              'Mô tả ngắn gọn về việc bạn cần giúp đỡ, thời gian dự kiến, phương thức liên lạc ưa thích, v.v.',

          // Screen Two - Form fields
          'team_size': 'Quy mô nhóm*',
          'team_size_format': '%s-%s người',
          'budget': 'Ngân sách*',
          'budget_format': '\$%s - \$%s USD',
          'need_help_with': 'Bạn cần giúp đỡ về điều gì?*',

          // Service options
          'web_design': 'Thiết kế Web',
          'ui_ux_design': 'Thiết kế UI/UX',
          'app_design': 'Thiết kế Ứng dụng',
          'development': 'Phát triển',
          'technical_seo': 'SEO Kỹ thuật',
          'content_writing': 'Viết nội dung',
          'strategy': 'Chiến lược',
          'research': 'Nghiên cứu',
          'other': 'Khác',
        },
      };
}
