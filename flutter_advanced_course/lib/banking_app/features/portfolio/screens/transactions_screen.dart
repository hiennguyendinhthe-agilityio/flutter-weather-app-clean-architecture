import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/banking_app/core/constants/app_colors.dart';
import 'package:flutter_advanced_course/banking_app/features/portfolio/models/transaction_model.dart';
import 'package:flutter_advanced_course/banking_app/features/portfolio/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _buildAnims(12);
    _animCtrl
      ..addListener(() => setState(() {}))
      ..forward();
  }

  void _buildAnims(int count) {
    _anims = List.generate(count, (i) {
      final s = (i * 0.06).clamp(0.0, 0.7);
      final e = (s + 0.3).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animCtrl,
          curve: Interval(s, e, curve: Curves.easeOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final grouped = provider.grouped;
    final sections = grouped.entries.toList();

    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          pinned: true,
          title: Text(
            'Transactions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.grey900,
            ),
          ),
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        ),

        // Sticky filter header
        SliverPersistentHeader(
          pinned: true,
          delegate: _FilterDelegate(
            selected: provider.selectedFilter,
            filters: provider.filters,
            onSelect: (f) {
              provider.setFilter(f);
              _animCtrl.reset();
              _animCtrl.forward();
            },
          ),
        ),

        // Loading state
        if (provider.isLoading)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, _) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: _TxSkeleton(),
              ),
              childCount: 5,
            ),
          )
        // Empty state
        else if (provider.transactions.isEmpty)
          const SliverFillRemaining(child: _EmptyState())
        // Grouped sections
        else
          ...sections.asMap().entries.expand((entry) {
            final sectionName = entry.value.key;
            final txList = entry.value.value;

            return [
              // Date group header
              SliverToBoxAdapter(child: _DateHeader(label: sectionName)),

              // Transactions in this group
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((ctx, i) {
                    final tx = txList[i];
                    final animIdx = i.clamp(0, _anims.length - 1);
                    return _TxTile(tx: tx, anim: _anims[animIdx]);
                  }, childCount: txList.length),
                ),
              ),
            ];
          }),

        // Bottom padding
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String label;
  const _DateHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white54 : AppColors.grey600,
        ),
      ),
    );
  }
}

class _TxTile extends StatelessWidget {
  final TransactionModel tx;
  final Animation<double> anim;

  const _TxTile({required this.tx, required this.anim});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: anim,
      builder: (_, child) => Opacity(
        opacity: anim.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset((1 - anim.value) * 30, 0),
          child: child,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            // RepaintBoundary: icon area stays painted
            // only amount/title trigger repaints
            RepaintBoundary(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color:
                      (tx.isExpense
                              ? AppColors.expense
                              : tx.isIncome
                              ? AppColors.income
                              : AppColors.primary)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  tx.icon,
                  color: tx.isExpense
                      ? AppColors.expense
                      : tx.isIncome
                      ? AppColors.income
                      : AppColors.primary,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDark ? Colors.white : AppColors.grey900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tx.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  tx.isExpense
                      ? '-'
                      : '+}'
                            '\$${tx.amount.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 2),
                Text(
                  '${tx.date.hour}:${tx.date.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.grey400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TxSkeleton extends StatelessWidget {
  const _TxSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.grey100,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.grey400),
          SizedBox(height: 12),
          Text(
            'No transactions found',
            style: TextStyle(color: AppColors.grey600, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

// ── Sticky filter delegate ────────────────────────
class _FilterDelegate extends SliverPersistentHeaderDelegate {
  final String selected;
  final List<String> filters;
  final ValueChanged<String> onSelect;

  const _FilterDelegate({
    required this.selected,
    required this.filters,
    required this.onSelect,
  });

  @override
  double get minExtent => 58;
  @override
  double get maxExtent => 58;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.darkBg : AppColors.grey50,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBg : AppColors.grey50,
          boxShadow: overlapsContent
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: filters.length,
          itemBuilder: (_, i) {
            final f = filters[i];
            final isSelected = selected == f;
            return GestureDetector(
              onTap: () => onSelect(f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.primary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_FilterDelegate old) => old.selected != selected;
}
