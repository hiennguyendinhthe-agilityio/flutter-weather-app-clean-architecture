import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/features/home/widgets/author/author_profile/author_profile.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/widgets/list_title/listtile.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../bloc/author_bloc/author_bloc.dart';
import '../../bloc/data_state.dart';
import '../../data/author_repository/author_repository.dart';

class Authors extends StatelessWidget {
  const Authors({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: BazUiBuiltInImage.icSearch(),
            onPressed: () {},
          ),
        ],
        title: Text(
          context.bazS.authorsTtile,
          style: context.textTheme.titleLarge
              ?.copyWith(fontSize: context.fontSize(SizeType.m)),
        ),
      ),
      body: BazUiTabbarView(
        headline: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.bazS.authorSubtitle,
                style: context.textTheme.labelMedium?.copyWith(
                  fontSize: context.fontSize(SizeType.m),
                ),
              ),
              Text(
                context.bazS.authorsTtile,
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.colorScheme.primary,
                  fontSize: context.fontSize(SizeType.m),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        tabs: [
          Tab(text: context.bazS.allTabBar),
          Tab(text: context.bazS.poetsTabBar),
          Tab(text: context.bazS.playwrightsTabBar),
          Tab(text: context.bazS.novelistsTabBar),
          Tab(text: context.bazS.journalistsTabBar),
          Tab(text: context.bazS.stationeryTabBar),
        ],
        child: [
          ListViewAuthors(filterOccupation: context.bazS.allTabBar),
          ListViewAuthors(filterOccupation: context.bazS.poetsTabBar),
          ListViewAuthors(filterOccupation: context.bazS.playwrightsTabBar),
          ListViewAuthors(filterOccupation: context.bazS.novelistsTabBar),
          ListViewAuthors(filterOccupation: context.bazS.journalistsTabBar),
          ListViewAuthors(filterOccupation: context.bazS.stationeryTabBar),
        ],
      ),
    );
  }
}

class ListViewAuthors extends StatelessWidget {
  const ListViewAuthors({
    super.key,
    required this.filterOccupation,
  });

  final String filterOccupation;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          AuthorBloc(repository: getIt<AuthorRepository>())
            ..add(
              GetAuthorsEvent(),
            ),
      child: BlocBuilder<AuthorBloc, FetchDataState<Author>>(
        builder: (context, state) {
          if (state.status == FetchDataStatus.error) {
            return Text(
              textAlign: TextAlign.center,
              'Error: ${state.errorMessage}',
            );
          }

          final List<Author>? filteredAuthors = _filteredAuthors(state);

          final int itemCount = state.status == FetchDataStatus.loaded
              ? filteredAuthors?.length ?? 0
              : 3;

          return Skeletonizer(
            enabled: state.status == FetchDataStatus.loading,
            child: (state.status == FetchDataStatus.loaded &&
                    (filteredAuthors?.isEmpty ?? true))
                ? BazUiEmpty(
                    onPressed: () {
                      context.read<AuthorBloc>().add(GetAuthorsEvent());
                    },
                  )
                : ListView.builder(
                    itemCount: itemCount,
                    itemBuilder: (_, index) {
                      final Author author =
                          state.status == FetchDataStatus.loading ||
                                  filteredAuthors == null
                              ? Author(id: index.toString())
                              : filteredAuthors[index];

                      return BazUiListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (BuildContext context) => AuthorBloc(
                                    repository: getIt<AuthorRepository>())
                                  ..add(
                                    GetAuthorsEvent(),
                                  ),
                                child: AuthorProfile(
                                  authorId: author.id,
                                ),
                              ),
                            ),
                          );
                        },
                        leading: author.avatarUrl,
                        title: author.fullName,
                        subtitle: author.biography,
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  /// Filter authors by author
  List<Author>? _filteredAuthors(FetchDataState<Author> state) {
    if (filterOccupation == 'All') {
      return state.data;
    }
    return state.data
        ?.where((author) => author.occupation == filterOccupation)
        .toList();
  }
}
