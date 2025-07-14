import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const CupertinoSliverNavigationBar(largeTitle: Text('Recent Activity')),
        _buildActivityList(),
      ],
    );
  }

  Widget _buildActivityList() {
    final activities = [
      'Pushed a new commit to flutter/flutter.',
      'Reviewed a pull request.',
      'Published a new package on pub.dev.',
      'Wrote an article about Advanced Slivers.',
      'Hosted a Flutter meetup.',
      'Fixed a critical bug.',
      'Mentored a junior developer.',
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Material(
          color: Colors.transparent,
          child: ListTile(
            leading: const Icon(CupertinoIcons.check_mark_circled),
            title: Text(activities[index]),
            subtitle: Text('${index + 1} day(s) ago'),
          ),
        );
      }, childCount: activities.length),
    );
  }
}
