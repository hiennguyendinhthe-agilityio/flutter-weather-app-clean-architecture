// // ignore_for_file: depend_on_referenced_packages

// import 'package:bazar_books_app/di.dart';
// import 'package:bazar_books_app/features/home/bloc/author_bloc/author_bloc.dart';
// import 'package:bazar_books_app/features/home/data/repository.dart';
// import 'package:bazar_books_app/features/home/widgets/author/authors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:widgetbook/widgetbook.dart';

// WidgetbookComponent authorsScreenWidgetbooks() {
//   return WidgetbookComponent(
//     name: 'AuthorsScreen',
//     useCases: [
//       WidgetbookUseCase(
//         name: 'AuthorsScreen',
//         builder: (context) {
//           return BlocProvider<AuthorBloc>(
//             create: (BuildContext context) =>
//                 AuthorBloc(repository: getIt<Repository>())
//                   ..add(
//                     FetchAllAuthorsEvent(),
//                   ),
//             child: const Authors(),
//           );
//         },
//       ),
//     ],
//   );
// }
