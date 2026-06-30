import 'package:flutter/material.dart';

class TransitionItem {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final Widget Function() destinationBuilder;

  TransitionItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.destinationBuilder,
  });
}

class TransitionHomeScreen extends StatefulWidget {
  const TransitionHomeScreen({super.key});

  @override
  State<TransitionHomeScreen> createState() => _TransitionHomeScreenState();
}

class _TransitionHomeScreenState extends State<TransitionHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _itemAnimations = List.generate(5, (index) {
      final start = index * 0.15;
      final end = (start + 0.4).clamp(0.0, 1.0);

      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _controller.addListener(() => setState(() {}));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late final List<TransitionItem> _transitions = [
    TransitionItem(
      title: 'Fade Transition',
      subtitle: 'opacity: 0.0 → 1.0',
      description:
          'The new screen gradually fades in. Ideal for dialogs and overlays.',
      icon: Icons.blur_on,
      color: const Color(0xFF6C63FF),
      destinationBuilder: () => const DemoScreen(
        title: 'Fade Transition',
        color: Color(0xFF6C63FF),
        description:
            'This screen appears by fading in from opacity 0.0 → 1.0.\n\n'
            'Use cases:\n• Switching between tabs\n• Opening dialogs\n• Content overlays',
      ),
    ),
    TransitionItem(
      title: 'Slide Up Transition',
      subtitle: 'Offset(0,1) → Offset(0,0)',
      description:
          'The screen slides up from the bottom. Used for modals and bottom sheets.',
      icon: Icons.arrow_upward,
      color: const Color(0xFF00BFA5),
      destinationBuilder: () => const DemoScreen(
        title: 'Slide Up',
        color: Color(0xFF00BFA5),
        description: 'This screen slides from the bottom to the top.\n\n'
            'Use cases:\n• Opening modal screens\n• Full-screen bottom sheets\n• Action sheets',
      ),
    ),
    TransitionItem(
      title: 'Scale Transition',
      subtitle: 'scale: 0.8 → 1.0 + fade',
      description:
          'The screen zooms in from a smaller size. Great for detail screens.',
      icon: Icons.zoom_out_map,
      color: const Color(0xFFFF6B6B),
      destinationBuilder: () => const DemoScreen(
        title: 'Scale Transition',
        color: Color(0xFFFF6B6B),
        description:
            'This screen scales up from 80% → 100% combined with a fade-in effect.\n\n'
            'Use cases:\n• Opening details from a list\n• Expanding cards\n• Zooming into content',
      ),
    ),
    TransitionItem(
      title: 'Shared Axis',
      subtitle: 'Both screens on the same axis',
      description:
          'Old screen exits to the left, new screen enters from the right.',
      icon: Icons.swap_horiz,
      color: const Color(0xFFFFB300),
      destinationBuilder: () => const DemoScreen(
        title: 'Shared Axis',
        color: Color(0xFFFFB300),
        description:
            'Screen A slides out to the left, Screen B slides in from the right.\n\n'
            'Use cases:\n• Onboarding steps\n• Wizards / multi-step forms\n• Sequential content',
      ),
    ),
    TransitionItem(
      title: 'Fade Through',
      subtitle: 'Fade out + scale down → Fade in',
      description:
          'Old screen fades/shrinks while the new screen fades/expands.',
      icon: Icons.compare_arrows,
      color: const Color(0xFF26C6DA),
      destinationBuilder: () => const DemoScreen(
        title: 'Fade Through',
        color: Color(0xFF26C6DA),
        description: 'Screen A: fade out + scale 1.0 → 0.92\n'
            'Screen B: fade in + scale 0.92 → 1.0\n\n'
            'Use cases:\n• Bottom navigation bars\n• Drawer navigation\n• Tab switching',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transition Demo')),
      backgroundColor: const Color(0xFFE5E5E5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Phase 2 - Page Transitions',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Transition Showcase',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tap each card to see the transition',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                itemCount: _transitions.length,
                itemBuilder: (context, index) {
                  final item = _transitions[index];
                  final anim = _itemAnimations[index];

                  return Opacity(
                    opacity: anim.value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - anim.value) * 30),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _buildTransitionCard(item, index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransitionCard(TransitionItem item, int index) {
    return GestureDetector(
      onTap: () => _navigate(item, index),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: item.color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(item.icon, color: item.color, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: item.color,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            Icon(Icons.play_circle_outline, color: item.color, size: 28),
          ],
        ),
      ),
    );
  }

  void _navigate(TransitionItem item, int index) {
    final destination = item.destinationBuilder();
    late Route route;

    switch (index) {
      case 0:
        route = _fadeRoute(destination);
        break;
      case 1:
        route = _slideUpRoute(destination);
        break;
      case 2:
        route = _scaleRoute(destination);
        break;
      case 3:
        route = _sharedAxisRoute(destination);
        break;
      case 4:
        route = _fadeThroughRoute(destination);
        break;
      default:
        route = _fadeRoute(destination);
    }
    Navigator.push(context, route);
  }
}

Route _fadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
  );
}

Route _slideUpRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      final fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        ),
      );

      return SlideTransition(
        position: slideAnimation,
        child: FadeTransition(opacity: fadeAnimation, child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
  );
}

Route _scaleRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );

      final scaleAnimation = Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(curved);

      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
      return ScaleTransition(
        scale: scaleAnimation,
        child: FadeTransition(opacity: fadeAnimation, child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
  );
}

Route _sharedAxisRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final enterSlide = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

      final enterFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: animation, curve: const Interval(0.0, 0.4)),
      );

      final exitSlide =
          Tween<Offset>(begin: Offset.zero, end: const Offset(-0.3, 0)).animate(
        CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeIn),
      );

      return Stack(
        children: [
          SlideTransition(position: exitSlide, child: const SizedBox.expand()),
          SlideTransition(
            position: enterSlide,
            child: FadeTransition(opacity: enterFade, child: child),
          ),
        ],
      );
    },
  );
}

Route _fadeThroughRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: secondaryAnimation,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
        ),
      );

      final exitScale = Tween<double>(begin: 1.0, end: 0.92).animate(
        CurvedAnimation(
          parent: secondaryAnimation,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
        ),
      );

      final enterFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
        ),
      );

      final enterScale = Tween<double>(begin: 0.92, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
        ),
      );

      return Stack(
        children: [
          FadeTransition(
            opacity: exitFade,
            child: ScaleTransition(scale: exitScale, child: Container()),
          ),
          FadeTransition(
            opacity: enterFade,
            child: ScaleTransition(scale: enterScale, child: child),
          ),
        ],
      );
    },
  );
}

class DemoScreen extends StatelessWidget {
  final String title;
  final Color color;
  final String description;

  const DemoScreen({
    super.key,
    required this.title,
    required this.color,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
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
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Destination Screen',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'How it works',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go back'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
