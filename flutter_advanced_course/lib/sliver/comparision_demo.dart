import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(length: 3, child: _ComparisonScreen()),
    );
  }
}

class _ComparisonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Column vs ListView vs Sliver'),
        backgroundColor: const Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
        bottom: const TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          indicatorColor: Color(0xFF6C63FF),
          tabs: [
            Tab(text: 'Column ❌'),
            Tab(text: 'ListView ✅'),
            Tab(text: 'Sliver 🚀'),
          ],
        ),
      ),
      body: const TabBarView(
        children: [_ColumnDemo(), _ListViewDemo(), _SliverDemo()],
      ),
    );
  }
}

class _ColumnDemo extends StatelessWidget {
  const _ColumnDemo();

  @override
  Widget build(BuildContext context) {
    int buildCount = 0;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.red.shade50,
            child: const Text(
              'Column + SingleChildScrollView\n'
              'All 50 items are BUILT IMMEDIATELY\n'
              'Even if you haven\'t scrolled to them!',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          ...List.generate(50, (index) {
            buildCount++;
            return _buildItem(
              index: index,
              subtitle: 'Built immediately (${buildCount}th build)',
              color: Colors.red,
            );
          }),
        ],
      ),
    );
  }
}

class _ListViewDemo extends StatelessWidget {
  const _ListViewDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: Colors.green.shade50,
          child: const Text(
            '✅ ListView.builder\n'
            'Items are BUILT only when near viewport\n'
            'Lazy rendering works!',
            style: TextStyle(
              color: Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 50,
            itemBuilder: (context, index) {
              debugPrint('ListView.builder: Building item $index');
              return _buildItem(
                index: index,
                subtitle: 'Built lazily when near viewport',
                color: Colors.green,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SliverDemo extends StatelessWidget {
  const _SliverDemo();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
            child: const Text(
              'CustomScrollView + Sliver\n'
              'Lazy rendering + Collapsible AppBar\n'
              '+ Sticky Header + Mix content!',
              style: TextStyle(
                color: Color(0xFF6C63FF),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            debugPrint('SliverList: Building item $index');
            return _buildItem(
              index: index,
              subtitle: 'Lazy + Sticky Header + CollapsibleAppBar',
              color: const Color(0xFF6C63FF),
            );
          }, childCount: 50),
        ),
      ],
    );
  }
}

Widget _buildItem({
  required int index,
  required String subtitle,
  required Color color,
}) {
  return Container(
    margin: const EdgeInsets.fromLTRB(16, 6, 16, 2),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withValues(alpha: 0.15)),
    ),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Item ${index + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
