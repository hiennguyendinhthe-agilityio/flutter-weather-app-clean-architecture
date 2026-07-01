import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/chart_demo/core/account_stats_theme.dart';
import 'package:flutter_advanced_course/chart_demo/models/statistic_data.dart';

// ─────────────────────────────────────────────────────────────
// USER STAT TABLE
// ─────────────────────────────────────────────────────────────

class UserStatTable extends StatelessWidget {
  const UserStatTable({super.key, required this.users});

  final List<AttributedUser> users;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Expanded(flex: 4, child: _HeaderCell('Nickname')),
              Expanded(flex: 3, child: _HeaderCell('Date')),
              Expanded(
                flex: 3,
                child: _HeaderCell('Resource', align: TextAlign.right),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // Data rows
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: users.length,
          separatorBuilder: (_, _) => Divider(
            color: Colors.white.withValues(alpha: 0.07),
            height: 1,
            thickness: 1,
          ),
          itemBuilder: (context, index) {
            return _UserRow(user: users[index]);
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// HEADER CELL
// ─────────────────────────────────────────────────────────────

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text, {this.align = TextAlign.left});
  final String text;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AccountStatsTheme.tableHeaderColor,
        letterSpacing: 0.2,
        fontFamily: 'SF Pro Display',
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// USER ROW
// ─────────────────────────────────────────────────────────────

class _UserRow extends StatelessWidget {
  const _UserRow({required this.user});
  final AttributedUser user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 4),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              user.nickname,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AccountStatsTheme.tableTextColor,
                fontFamily: 'SF Pro Display',
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              user.formattedDate,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AccountStatsTheme.tableTextColor,
                fontFamily: 'SF Pro Display',
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              user.resource,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AccountStatsTheme.tableTextColor,
                fontFamily: 'SF Pro Display',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
