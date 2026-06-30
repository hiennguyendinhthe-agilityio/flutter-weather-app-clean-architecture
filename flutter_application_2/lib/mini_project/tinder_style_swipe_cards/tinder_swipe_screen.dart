import 'package:flutter/material.dart';

// ignore: always_use_package_imports
import 'card_data.dart';

class TinderSwipeScreen extends StatefulWidget {
  const TinderSwipeScreen({super.key});
  @override
  State<TinderSwipeScreen> createState() => _TinderSwipeScreenState();
}

class _TinderSwipeScreenState extends State<TinderSwipeScreen> {
  late List<CardData> _cards;

  int _likeCount = 0;
  int _nopeCount = 0;

  final List<_SwipeAction> _history = [];

  @override
  void initState() {
    super.initState();

    _cards = List.from(cardDataList);
  }

  void _onCardSwiped(CardData card, bool isLike) {
    setState(() {
      _cards.removeAt(0);

      if (isLike) {
        _likeCount++;
      } else {
        _nopeCount++;
      }

      _history.add(_SwipeAction(card: card, isLike: isLike));
    });
  }

  void _onUndo() {
    if (_history.isEmpty) return;
    setState(() {
      final lastAction = _history.removeLast();

      _cards.insert(0, lastAction.card);

      if (lastAction.isLike) {
        _likeCount--;
      } else {
        _nopeCount--;
      }
    });
  }

  void _onReset() {
    setState(() {
      _cards = List.from(cardDataList);
      _likeCount = 0;
      _nopeCount = 0;
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0FF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  const Text(
                    'Swipe Cards',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const Spacer(),
                  if (_history.isNotEmpty)
                    GestureDetector(
                      onTap: _onUndo,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.undo, color: Color(0xFF6C63FF)),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildCounter(
                    count: _nopeCount,
                    label: 'Nope',
                    color: Colors.red,
                    icon: Icons.close,
                  ),
                  const Spacer(),
                  Text(
                    '${_cards.length} cards left',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                  const Spacer(),
                  _buildCounter(
                    count: _likeCount,
                    label: 'Like',
                    color: Colors.green,
                    icon: Icons.favorite,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _cards.isEmpty ? _buildEmptyState() : _buildCardStack(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.close,
                    color: Colors.red,
                    size: 56,
                    onTap: _cards.isEmpty
                        ? null
                        : () => _onCardSwiped(_cards[0], false),
                  ),
                  _buildActionButton(
                    icon: Icons.refresh,
                    color: Colors.grey,
                    size: 44,
                    onTap: _onReset,
                  ),
                  _buildActionButton(
                    icon: Icons.favorite,
                    color: Colors.green,
                    size: 56,
                    onTap: _cards.isEmpty
                        ? null
                        : () => _onCardSwiped(_cards[0], true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardStack() {
    final visibleCards = _cards.take(3).toList();

    return Stack(
      alignment: Alignment.center,
      children: visibleCards
          .asMap()
          .entries
          .map((entry) {
            final index = entry.key;
            final card = entry.value;

            if (index == 0) {
              return SwipeCard(
                key: ValueKey(card.name),
                cardData: card,
                onSwiped: _onCardSwiped,
              );
            } else {
              final scale = 0.88 + index * 0.06;

              final offset = index * 10.0;

              return Transform.translate(
                offset: Offset(0, offset),
                child: Transform.scale(
                  scale: scale,
                  child: SwipeCard(
                    key: ValueKey(card.name),
                    cardData: card,
                    onSwiped: null,
                  ),
                ),
              );
            }
          })
          .toList()
          .reversed
          .toList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.done_all, size: 72, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No more cards!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '❤️ $likeCount Likes  •  ❌ $nopeCount Nopes',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _onReset,
            icon: const Icon(Icons.refresh),
            label: const Text('Start over'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int get likeCount => _likeCount;
  int get nopeCount => _nopeCount;

  Widget _buildCounter({
    required int count,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text(
          '$count $label',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required double size,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: size * 0.45),
      ),
    );
  }
}

class SwipeCard extends StatefulWidget {
  final CardData cardData;

  final Function(CardData card, bool isLike)? onSwiped;

  const SwipeCard({super.key, required this.cardData, required this.onSwiped});

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Offset> _positionAnimation;

  Offset _position = Offset.zero;

  Offset _velocity = Offset.zero;

  bool _isDragging = false;

  static const double _swipeThreshold = 150.0;

  static const double _flyOutDistance = 600.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_controller);

    _controller.addListener(() {
      if (!_isDragging) {
        setState(() {
          _position = _positionAnimation.value;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _rotationAngle {
    return (_position.dx / 1000).clamp(-0.4, 0.4);
  }

  double get _likeOpacity {
    if (_position.dx <= 0) return 0;
    return (_position.dx / _swipeThreshold).clamp(0.0, 1.0);
  }

  double get _nopeOpacity {
    if (_position.dx >= 0) return 0;
    return (_position.dx.abs() / _swipeThreshold).clamp(0.0, 1.0);
  }

  void _onPanStart(DragStartDetails details) {
    if (widget.onSwiped == null) return;
    _controller.stop();
    _isDragging = true;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (widget.onSwiped == null) return;
    setState(() {
      _position += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (widget.onSwiped == null) return;
    _isDragging = false;

    _velocity = details.velocity.pixelsPerSecond;

    final bool shouldFlyRight = _position.dx > _swipeThreshold;
    final bool shouldFlyLeft = _position.dx < -_swipeThreshold;

    if (shouldFlyRight) {
      _flyOut(isRight: true);
    } else if (shouldFlyLeft) {
      _flyOut(isRight: false);
    } else {
      _springBack();
    }
  }

  void _flyOut({required bool isRight}) {
    final endX = isRight ? _flyOutDistance : -_flyOutDistance;

    final endY = _position.dy +
        (_velocity.dy / _velocity.dx.abs() * endX.abs()).clamp(-300.0, 300.0);

    _positionAnimation = Tween<Offset>(
      begin: _position,
      end: Offset(endX, endY),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.reset();
    _controller.forward().then((_) {
      widget.onSwiped?.call(widget.cardData, isRight);
    });
  }

  void _springBack() {
    _positionAnimation = Tween<Offset>(
      begin: _position,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller
      ..duration = const Duration(milliseconds: 600)
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onSwiped == null) {
      return _buildCardContent(opacity: 1.0);
    }

    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Transform.translate(
        offset: _position,
        child: Transform.rotate(
          angle: _rotationAngle,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _buildCardContent(opacity: 1.0),
              Positioned(
                top: 30,
                left: 20,
                child: Opacity(
                  opacity: _likeOpacity,
                  child: Transform.rotate(
                    angle: -0.3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'LIKE',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 30,
                right: 20,
                child: Opacity(
                  opacity: _nopeOpacity,
                  child: Transform.rotate(
                    angle: 0.3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'NOPE',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent({required double opacity}) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 300,
        height: 400,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.cardData.color,
              widget.cardData.color.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: widget.cardData.color.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.cardData.icon, color: Colors.white, size: 52),
            ),
            const SizedBox(height: 24),
            Text(
              widget.cardData.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.cardData.role,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: widget.cardData.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.swipe,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'Swipe left or right',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 13,
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

class _SwipeAction {
  final CardData card;
  final bool isLike;
  const _SwipeAction({required this.card, required this.isLike});
}
