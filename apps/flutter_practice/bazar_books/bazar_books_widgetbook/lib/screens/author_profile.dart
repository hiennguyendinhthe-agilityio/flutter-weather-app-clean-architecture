// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_app/features/home/widgets/author/author_profile/author_profile.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent authorProfileScreenWidgetbooks() {
  return WidgetbookComponent(
    name: 'AuthorProfileScreen',
    useCases: [
      WidgetbookUseCase(
        name: 'AuthorProfileScreen',
        builder: (context) {
          return const AuthorProfile(
            authorId: '1',
          );
        },
      ),
    ],
  );
}
