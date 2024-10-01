import 'package:bazar_books_app/features/home/bloc/author_bloc/author_bloc.dart';
import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AuthorsSection extends StatelessWidget {
  const AuthorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: BlocBuilder<AuthorBloc, FetchDataState<Author>>(
        builder: (context, state) {
          if (state.status == FetchDataStatus.error) {
            return Text(
              textAlign: TextAlign.center,
              'Error: ${state.errorMessage}',
            );
          }

          return Skeletonizer(
            enabled: state.status == FetchDataStatus.loading,
            child: ((state.status == FetchDataStatus.loaded) &&
                    (state.data?.isEmpty ?? false))
                ? BazUiEmpty(
                    onPressed: () {
                      context.read<AuthorBloc>().add(GetAuthorsEvent());
                    },
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (state.status == FetchDataStatus.loaded
                        ? state.data?.length ?? 0
                        : 3),
                    itemBuilder: (_, index) {
                      final Author author = state.status ==
                                  FetchDataStatus.loading ||
                              state.data == null
                          ? Author(id: index.toString())
                          : state.data?[index] ?? Author(id: index.toString());

                      return BazUiAuthor(
                        fullName: author.fullName,
                        occupation: author.occupation,
                        imageUrl: author.avatarUrl,
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
