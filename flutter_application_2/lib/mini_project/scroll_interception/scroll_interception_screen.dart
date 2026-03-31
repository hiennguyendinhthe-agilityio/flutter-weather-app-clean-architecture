import 'package:flutter/material.dart';
import 'package:flutter_application_2/mini_project/scroll_interception/data/items.dart';
import 'package:flutter_application_2/mini_project/scroll_interception/debug_panel.dart';
import 'package:flutter_application_2/mini_project/scroll_interception/knowledge_card.dart';
import 'package:flutter_application_2/mini_project/scroll_interception/scroll_debug_info.dart';
import 'package:flutter_application_2/mini_project/scroll_interception/simple_header.dart';
import 'package:flutter_application_2/mini_project/scroll_interception/threshold_indicator.dart';

class ScrollInterceptionScreen extends StatefulWidget {
  const ScrollInterceptionScreen({super.key});

  @override
  State<ScrollInterceptionScreen> createState() =>
      _ScrollInterceptionScreenState();
}

class _ScrollInterceptionScreenState extends State<ScrollInterceptionScreen> {
  late final ScrollController _scrollController;

  final ValueNotifier<bool> _showBackToTop = ValueNotifier(false);

  static const double _showButtonThreshold = 500.0;

  final ValueNotifier<ScrollDebugInfo> _debugInfo = ValueNotifier(
    ScrollDebugInfo.empty(),
  );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollControllerUpdate);
  }

  void _onScrollControllerUpdate() {
    if (!_scrollController.hasClients) {
      return;
    }
    final offset = _scrollController.offset;

    _showBackToTop.value = offset > _showButtonThreshold;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollControllerUpdate);
    _showBackToTop.dispose();
    _debugInfo.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        final metrics = notification.metrics;

        if (notification is ScrollStartNotification) {
          debugPrint(
            '🟡 ScrollStart | '
            'pixels: ${metrics.pixels.toStringAsFixed(1)}px | '
            'axis: ${metrics.axis.name}',
          );
        } else if (notification is ScrollUpdateNotification) {
          debugPrint(
            '🔵 ScrollUpdate | '
            'pixels: ${metrics.pixels.toStringAsFixed(1)}px | '
            'maxExtent: ${metrics.maxScrollExtent.toStringAsFixed(1)}px | '
            'scrollDelta: ${notification.scrollDelta?.toStringAsFixed(2) ?? 'null'}px | '
            'progress: ${metrics.maxScrollExtent > 0 ? (metrics.pixels / metrics.maxScrollExtent * 100).toStringAsFixed(1) : 0}%',
          );
        } else if (notification is ScrollEndNotification) {
          debugPrint(
            '🔴 ScrollEnd | '
            'pixels: ${metrics.pixels.toStringAsFixed(1)}px | '
            'atEdge: ${metrics.atEdge}',
          );
        }
        _debugInfo.value = ScrollDebugInfo(
          pixels: metrics.pixels,
          maxExtent: metrics.maxScrollExtent,
          viewportDimension: metrics.viewportDimension,
          atEdge: metrics.atEdge,
          phase: notification is ScrollStartNotification
              ? 'Start 🟡'
              : notification is ScrollUpdateNotification
              ? 'Update 🔵'
              : 'End 🔴',
          scrollDelta: notification is ScrollUpdateNotification
              ? (notification).scrollDelta ?? 0
              : 0,
        );

        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFE5E5E5),
        floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: _showBackToTop,
          builder: (context, showButton, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: showButton
                  ? FloatingActionButton.extended(
                      key: const ValueKey('show'),
                      onPressed: _scrollToTop,
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      icon: const Icon(Icons.arrow_upward, size: 18),
                      label: const Text(
                        'Back to Top',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          },
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              floating: false,
              backgroundColor: const Color(0xFF1A1A2E),
              forceMaterialTransparency: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Scroll Interception',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                  ),
                ),
                titlePadding: const EdgeInsetsDirectional.only(
                  start: 16,
                  bottom: 16,
                ),
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1A1A2E), Color(0xFF6C63FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30),
                          Icon(Icons.touch_app, color: Colors.white, size: 48),
                          SizedBox(height: 8),
                          Text(
                            'Scroll down to see\nNotification events',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: ValueListenableBuilder<ScrollDebugInfo>(
                valueListenable: _debugInfo,
                builder: (context, info, child) {
                  return DebugPanel(info: info);
                },
              ),
            ),

            SliverToBoxAdapter(
              child: ValueListenableBuilder<bool>(
                valueListenable: _showBackToTop,
                builder: (context, showButton, child) {
                  return ThresholdIndicator(
                    showButton: showButton,
                    threshold: _showButtonThreshold,
                    debugInfo: _debugInfo,
                  );
                },
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              sliver: SliverPersistentHeader(
                pinned: false,
                delegate: SimpleHeader(
                  title: '📚 Flutter Knowledge Base',
                  subtitle: '${items.length} articles',
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = items[index];
                  return KnowledgeCard(
                    index: index,
                    title: item['title'] as String,
                    subtitle: item['sub'] as String,
                    color: Color(item['color'] as int),
                  );
                }, childCount: items.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
