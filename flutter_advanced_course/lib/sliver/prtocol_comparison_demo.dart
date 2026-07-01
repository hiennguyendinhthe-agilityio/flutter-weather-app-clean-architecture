import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProtocolComparisonScreen(),
    );
  }
}

class ProtocolComparisonScreen extends StatefulWidget {
  const ProtocolComparisonScreen({super.key});

  @override
  State<ProtocolComparisonScreen> createState() =>
      _ProtocolComparisonScreenState();
}

class _ProtocolComparisonScreenState extends State<ProtocolComparisonScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    const appBarExpandedHeight = 200.0;
    const appBarPinnedHeight = 56.0;

    final appBarScrolled = _scrollOffset.clamp(
      0,
      appBarExpandedHeight - appBarPinnedHeight,
    );
    final currentAppBarHeight = appBarExpandedHeight - appBarScrolled;

    final appBarPaintExtent = currentAppBarHeight;

    final appBarLayoutExtent = _scrollOffset > 0
        ? appBarPinnedHeight
        : appBarExpandedHeight;

    final remainingPaintExtent = screenHeight - appBarPaintExtent;

    final overlap = appBarPaintExtent - appBarLayoutExtent;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              const SliverAppBar(
                expandedHeight: appBarExpandedHeight,
                pinned: true,
                backgroundColor: Color(0xFF1A1A2E),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Protocol Inspector',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  background: _AppBarBackground(),
                ),
              ),

              SliverToBoxAdapter(
                child: _ConstraintsPanel(
                  scrollOffset: _scrollOffset,
                  remainingPaintExtent: remainingPaintExtent,
                  crossAxisExtent: screenWidth,
                  viewportMainAxisExtent: screenHeight,
                  overlap: overlap,
                  appBarPaintExtent: appBarPaintExtent,
                  appBarLayoutExtent: appBarLayoutExtent,
                ),
              ),

              _GeometryVisualizerSliver(scrollOffset: _scrollOffset),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildItem(index),
                  childCount: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(int index) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.layers, color: Color(0xFF6C63FF), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sliver Item ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Scroll to see constraints change',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConstraintsPanel extends StatelessWidget {
  final double scrollOffset;
  final double remainingPaintExtent;
  final double crossAxisExtent;
  final double viewportMainAxisExtent;
  final double overlap;
  final double appBarPaintExtent;
  final double appBarLayoutExtent;

  const _ConstraintsPanel({
    required this.scrollOffset,
    required this.remainingPaintExtent,
    required this.crossAxisExtent,
    required this.viewportMainAxisExtent,
    required this.overlap,
    required this.appBarPaintExtent,
    required this.appBarLayoutExtent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bug_report, color: Colors.greenAccent, size: 18),
              SizedBox(width: 8),
              Text(
                'SliverConstraints Inspector',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(
            'Scroll to see values change in real-time',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 11,
            ),
          ),

          const Divider(color: Colors.white12, height: 20),

          _buildSection('📥 SliverConstraints (Input)', [
            _buildRow(
              'scrollOffset',
              scrollOffset.toStringAsFixed(1),
              Colors.orangeAccent,
              'px scrolled past this Sliver',
            ),
            _buildRow(
              'remainingPaintExtent',
              remainingPaintExtent.toStringAsFixed(1),
              Colors.lightBlueAccent,
              'px left to paint',
            ),
            _buildRow(
              'crossAxisExtent',
              crossAxisExtent.toStringAsFixed(1),
              Colors.greenAccent,
              'viewport width',
            ),
            _buildRow(
              'viewportMainAxisExtent',
              viewportMainAxisExtent.toStringAsFixed(1),
              Colors.purpleAccent,
              'viewport height',
            ),
            _buildRow(
              'overlap',
              overlap.toStringAsFixed(1),
              Colors.redAccent,
              'px overlap',
            ),
          ]),

          const SizedBox(height: 12),

          _buildSection('📤 SliverGeometry (Output – AppBar)', [
            _buildRow(
              'paintExtent',
              appBarPaintExtent.toStringAsFixed(1),
              Colors.yellowAccent,
              'px actually painted',
            ),
            _buildRow(
              'layoutExtent',
              appBarLayoutExtent.toStringAsFixed(1),
              Colors.cyanAccent,
              'px occupies space in layout',
            ),
            _buildRow(
              'overlap (paint-layout)',
              (appBarPaintExtent - appBarLayoutExtent).toStringAsFixed(1),
              Colors.pinkAccent,
              'px overlap',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...rows,
      ],
    );
  }

  Widget _buildRow(
    String name,
    String value,
    Color valueColor,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),

          SizedBox(
            width: 60,
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),

          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GeometryVisualizerSliver extends StatelessWidget {
  final double scrollOffset;

  const _GeometryVisualizerSliver({required this.scrollOffset});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.schema, color: Color(0xFF6C63FF), size: 18),
                const SizedBox(width: 8),
                const Text(
                  'Geometry Visualizer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'scroll: ${scrollOffset.toStringAsFixed(0)}px',
                    style: const TextStyle(
                      color: Color(0xFF6C63FF),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildLegend(),

            const SizedBox(height: 16),

            _buildExplanationCard(
              icon: Icons.brush,
              color: Colors.orange,
              title: 'paintExtent',
              formula: 'min(scrollExtent - scrollOffset, remainingPaintExtent)',
              explanation:
                  'The actual painted area of the sliver on the screen. '
                  'Cannot exceed remainingPaintExtent.',
            ),

            const SizedBox(height: 8),

            _buildExplanationCard(
              icon: Icons.space_bar,
              color: Colors.blue,
              title: 'layoutExtent',
              formula: 'Usually = paintExtent, unless overlap',
              explanation:
                  'The area of the Sliver that occupies space in the layout. '
                  'The next sliver starts after layoutExtent. '
                  'When AppBar pinned: layoutExtent < paintExtent → overlap.',
            ),

            const SizedBox(height: 8),

            _buildExplanationCard(
              icon: Icons.height,
              color: Colors.green,
              title: 'scrollExtent',
              formula: 'Total height of Sliver content',
              explanation:
                  'Viewport uses scrollExtent to calculate the total '
                  'scroll range. SliverList 100 items × 60px '
                  '= scrollExtent: 6000px.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _buildLegendItem(Colors.orange, 'paintExtent'),
        _buildLegendItem(Colors.blue, 'layoutExtent'),
        _buildLegendItem(Colors.green, 'scrollExtent'),
        _buildLegendItem(Colors.red, 'overlap'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 12,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildExplanationCard({
    required IconData icon,
    required Color color,
    required String title,
    required String formula,
    required String explanation,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              formula,
              style: TextStyle(
                color: color.withValues(alpha: 0.8),
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 6),

          Text(
            explanation,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarBackground extends StatelessWidget {
  const _AppBarBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF6C63FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Icon(Icons.layers, color: Colors.white, size: 40),
            SizedBox(height: 8),
            Text(
              'Box vs Sliver Protocol',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Scroll to see constraints changes',
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
