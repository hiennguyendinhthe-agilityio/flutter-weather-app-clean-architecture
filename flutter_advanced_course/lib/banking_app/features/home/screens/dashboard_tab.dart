import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/banking_app/core/constants/app_colors.dart';
import 'package:flutter_advanced_course/banking_app/core/utils/formatters.dart';
import 'package:flutter_advanced_course/banking_app/features/auth/models/user_model.dart';
import 'package:flutter_advanced_course/banking_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_advanced_course/banking_app/features/home/models/account_model.dart';
import 'package:flutter_advanced_course/banking_app/features/home/providers/home_provider.dart';
import 'package:flutter_advanced_course/banking_app/features/portfolio/models/transaction_model.dart';
import 'package:flutter_advanced_course/banking_app/features/portfolio/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  final _showFab = ValueNotifier<bool>(false);

  late AnimationController _staggerCtrl;
  late List<Animation<double>> _staggerAnims;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      _showFab.value = _scrollController.offset > 280;
    });

    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _staggerAnims = List.generate(4, (i) {
      final s = i * 0.18;
      final e = (s + 0.45).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _staggerCtrl,
          curve: Interval(s, e, curve: Curves.easeOut),
        ),
      );
    });

    _staggerCtrl.addListener(() => setState(() {}));

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _staggerCtrl.forward();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _showFab.dispose();
    _staggerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final home = context.watch<HomeProvider>();
    final txProvider = context.watch<TransactionProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Back-to-top FAB — only rebuilds FAB widget
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _showFab,
        builder: (_, show, _) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: show
              ? FloatingActionButton.small(
                  key: const ValueKey('fab_on'),
                  backgroundColor: AppColors.primary,
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                    );
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: Colors.white,
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('fab_off')),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // ── Collapsing AppBar ──────────────────
          _DashboardAppBar(user: auth.user),

          // ── Balance Card ───────────────────────
          SliverToBoxAdapter(
            child: _stagger(
              0,
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: home.isLoading
                    ? const _SkeletonBox(height: 180)
                    : home.account != null
                    ? _BalanceCard(account: home.account!)
                    : const _EmptyCard(),
              ),
            ),
          ),

          // ── Quick Actions ──────────────────────
          SliverToBoxAdapter(child: _stagger(1, const _QuickActions())),

          // ── Recent Transactions header ─────────
          SliverToBoxAdapter(
            child: _stagger(
              2,
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.grey900,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Recent Transactions list ───────────
          if (txProvider.isLoading)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, _) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: _SkeletonBox(height: 68),
                ),
                childCount: 3,
              ),
            )
          else if (txProvider.transactions.isEmpty)
            const SliverToBoxAdapter(child: _EmptyTransactions())
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final tx = txProvider.transactions.take(5).elementAt(index);

                  return _stagger(3, _TransactionRow(transaction: tx));
                }, childCount: txProvider.transactions.take(5).length),
              ),
            ),
        ],
      ),
    );
  }

  Widget _stagger(int i, Widget child) {
    if (i >= _staggerAnims.length) return child;
    final a = _staggerAnims[i];
    return Opacity(
      opacity: a.value.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, (1 - a.value) * 16),
        child: child,
      ),
    );
  }
}

// ════════════════════════════════════════════════
// DASHBOARD APP BAR
// FIX: Uses LayoutBuilder to prevent overflow
// ════════════════════════════════════════════════
class _DashboardAppBar extends StatelessWidget {
  final UserModel? user;

  const _DashboardAppBar({required this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: 130,
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        // FIX: collapseMode.none prevents
        // background from being clipped incorrectly
        collapseMode: CollapseMode.none,
        background: SafeArea(
          // FIX: bottom:false prevents extra padding
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              // FIX: mainAxisSize.min prevents
              // Column from expanding infinitely
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good morning 👋',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.white54
                                  : AppColors.grey600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.firstName ?? 'User',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.grey900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Avatar
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          user?.initials ?? 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // FIX: title appears when collapsed (pinned)
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.grey900,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        titlePadding: const EdgeInsetsDirectional.only(start: 20, bottom: 14),
      ),
    );
  }
}

// ════════════════════════════════════════════════
// BALANCE CARD – Animated balance counter
// ════════════════════════════════════════════════
class _BalanceCard extends StatefulWidget {
  final AccountModel account;
  const _BalanceCard({required this.account});

  @override
  State<_BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<_BalanceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _balanceAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _balanceAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.4));
    _ctrl
      ..addListener(() => setState(() {}))
      ..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Animated balance value
    final displayBalance = widget.account.balance * _balanceAnim.value;

    return Container(
      // FIX: No fixed height — let content define height
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        // FIX: mainAxisSize.min — no forced expansion
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account number + card type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: _fadeAnim.value,
                child: Text(
                  widget.account.accountNumber,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 13,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Opacity(
                opacity: _fadeAnim.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'VISA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Balance label
          Text(
            'Total Balance',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),

          // Animated balance
          Text(
            '\$${AppFormatters.addCommas(displayBalance.toStringAsFixed(2))}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 20),

          // Income / Expenses row
          Opacity(
            opacity: _fadeAnim.value,
            child: Row(
              children: [
                _MiniStat(
                  icon: Icons.arrow_downward_rounded,
                  label: 'Income',
                  value: AppFormatters.formatCurrencyShort(
                    widget.account.income,
                  ),
                  color: Colors.greenAccent,
                ),
                const SizedBox(width: 28),
                _MiniStat(
                  icon: Icons.arrow_upward_rounded,
                  label: 'Expenses',
                  value: AppFormatters.formatCurrencyShort(
                    widget.account.expenses,
                  ),
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 11,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════
// QUICK ACTIONS
// ════════════════════════════════════════════════
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  static const _actions = [
    (Icons.send_rounded, 'Send', AppColors.primary),
    (Icons.download_rounded, 'Receive', AppColors.accent),
    (Icons.credit_card_rounded, 'Cards', AppColors.warning),
    (Icons.more_horiz_rounded, 'More', AppColors.grey600),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _actions
            .map((a) => _ActionItem(icon: a.$1, label: a.$2, color: a.$3))
            .toList(),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white60 : AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════
// TRANSACTION ROW (on dashboard)
// ════════════════════════════════════════════════
class _TransactionRow extends StatelessWidget {
  final TransactionModel transaction;

  const _TransactionRow({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isExpense = transaction.type == 'expense';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          // Icon — RepaintBoundary prevents repaint
          // when only text/amount changes
          RepaintBoundary(
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (isExpense ? AppColors.expense : AppColors.income)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                transaction.icon,
                color: isExpense ? AppColors.expense : AppColors.income,
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
                  transaction.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDark ? Colors.white : AppColors.grey900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isExpense ? '-' : '+'}'
            '\$${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isExpense ? AppColors.expense : AppColors.income,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════
// SKELETON LOADING
// ════════════════════════════════════════════════
class _SkeletonBox extends StatefulWidget {
  final double height;
  const _SkeletonBox({required this.height});

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _ctrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: isDark
            ? Color.lerp(AppColors.darkCard, AppColors.darkSurface, _anim.value)
            : Color.lerp(AppColors.grey200, AppColors.grey100, _anim.value),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          'Failed to load account',
          style: TextStyle(color: AppColors.grey600),
        ),
      ),
    );
  }
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined, size: 56, color: AppColors.grey400),
          SizedBox(height: 12),
          Text(
            'No transactions yet',
            style: TextStyle(color: AppColors.grey600, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
