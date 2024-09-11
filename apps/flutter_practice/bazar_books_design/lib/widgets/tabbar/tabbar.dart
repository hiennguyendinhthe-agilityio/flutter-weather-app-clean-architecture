import 'package:flutter/material.dart';

class BazUiTabbarView extends StatefulWidget {
  const BazUiTabbarView({
    super.key,
    required this.tabs,
    required this.child,
    this.headline = const SizedBox.shrink(),
  });

  final List<Widget> tabs;
  final List<Widget> child;
  final Widget headline;

  @override
  State<BazUiTabbarView> createState() => _BazUiTabbarViewState();
}

class _BazUiTabbarViewState extends State<BazUiTabbarView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.headline,
        TabBar(
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          controller: _tabController,
          tabs: widget.tabs,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.child,
          ),
        ),
      ],
    );
  }
}
