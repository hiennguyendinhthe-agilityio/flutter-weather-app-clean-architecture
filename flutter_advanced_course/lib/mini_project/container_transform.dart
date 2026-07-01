import 'package:flutter/material.dart';

class Article {
  final String id;
  final String title;
  final String category;
  final String content;
  final Color color;
  final IconData icon;

  const Article({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    required this.color,
    required this.icon,
  });
}

const List<Article> articles = [
  Article(
    id: 'flutter',
    title: 'Flutter 3.0 Released',
    category: 'Technology',
    content: 'Flutter 3.0 brings major improvements to performance, '
        'adds support for all 6 platforms simultaneously, and introduces '
        'Material Design 3. The new release focuses on stability and '
        'developer experience with hundreds of bug fixes.\n\n'
        'Key highlights include improved rendering performance, '
        'better accessibility support, and new widget catalog.',
    color: Color(0xFF6C63FF),
    icon: Icons.flutter_dash,
  ),
  Article(
    id: 'animation',
    title: 'Animation Deep Dive',
    category: 'Tutorial',
    content: 'Understanding Flutter animations from the ground up. '
        'This comprehensive guide covers implicit animations, explicit '
        'animations, physics-based motion, and custom painters.\n\n'
        'Learn how AnimationController, Tween, and CurvedAnimation '
        'work together to create smooth, natural-feeling UI.',
    color: Color(0xFFFF6B6B),
    icon: Icons.animation,
  ),
  Article(
    id: 'performance',
    title: 'Performance Tips',
    category: 'Best Practices',
    content: 'Top 10 performance tips every Flutter developer should know. '
        'From const constructors to RepaintBoundary, these techniques '
        'will help you achieve 60fps on any device.\n\n'
        'Covers widget rebuilds, layout thrashing, image caching, '
        'and DevTools profiling techniques.',
    color: Color(0xFF00BFA5),
    icon: Icons.speed,
  ),
];

class ContainerTransformDemo extends StatelessWidget {
  const ContainerTransformDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        title: const Text(
          'Container Transform',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];

          return Hero(
            tag: 'article-${article.id}',
            flightShuttleBuilder: (
              flightContext,
              animation,
              flightDirection,
              fromHeroContext,
              toHeroContext,
            ) {
              return AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  final borderRadius = BorderRadiusTween(
                    begin: BorderRadius.circular(20),
                    end: BorderRadius.zero,
                  ).evaluate(animation);

                  return Material(
                    borderRadius: borderRadius,
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      decoration: BoxDecoration(
                        color: article.color,
                        borderRadius: borderRadius,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Opacity(
                            opacity: animation.value,
                            child: _buildDetailContent(article),
                          ),
                          Opacity(
                            opacity: 1 - animation.value,
                            child: _buildCardContent(article),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, _containerTransformRoute(article));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                height: 120,
                decoration: BoxDecoration(
                  color: article.color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: article.color.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: _buildCardContent(article),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardContent(Article article) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(article.icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  article.category,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  article.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
        ],
      ),
    );
  }

  Widget _buildDetailContent(Article article) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(article.icon, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          Text(
            article.category.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            article.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            article.content,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 15,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: 'article-${article.id}',
        child: Material(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: article.color,
            child: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Icon(article.icon, color: Colors.white, size: 56),
                        const SizedBox(height: 20),
                        Text(
                          article.category.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          height: 2,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          article.content,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 16,
                            height: 1.8,
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Route _containerTransformRoute(Article article) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 450),
    pageBuilder: (context, animation, secondaryAnimation) =>
        ArticleDetailScreen(article: article),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        child,
  );
}
