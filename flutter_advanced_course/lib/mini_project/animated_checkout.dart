import 'dart:math';

import 'package:flutter/material.dart';

enum _ButtonState { idle, loading, done }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _widthAnimation;

  late Animation<double> _textOpacityAnimation;

  late Animation<double> _spinnerOpacityAnimation;

  late Animation<double> _spinnerRotationAnimation;

  late Animation<double> _checkOpacityAnimation;

  late Animation<double> _checkScaleAnimation;

  _ButtonState _buttonState = _ButtonState.idle;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _widthAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 250,
          end: 60,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(60), weight: 40),
      TweenSequenceItem(tween: ConstantTween<double>(60), weight: 30),
    ]).animate(_controller);

    _textOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 70),
    ]).animate(_controller);

    _spinnerOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 30),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 40),
    ]).animate(_controller);

    _spinnerRotationAnimation = Tween<double>(
      begin: 0,
      end: 4 * pi,
    ).animate(_controller);

    _checkOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 70),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_controller);

    _checkScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 70),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _buttonState = _ButtonState.done;
        });
      }
    });

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCheckoutPressed() {
    if (_buttonState != _ButtonState.idle) return;

    setState(() {
      _buttonState = _ButtonState.loading;
    });

    _controller.forward();
  }

  void onRest() {
    _controller.reset();
    setState(() {
      _buttonState = _ButtonState.idle;
    });
  }

  Color get _buttonColor {
    switch (_buttonState) {
      case _ButtonState.idle:
        return Colors.deepPurple;
      case _ButtonState.loading:
        return Colors.deepPurple.shade300;
      case _ButtonState.done:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Animated Checkout'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.phone_iphone, color: Colors.deepPurple),
                    title: Text('iPhone 15'),
                    trailing: Text('\$999'),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.headphones, color: Colors.deepPurple),
                    title: Text('AirPods Pro'),
                    trailing: Text('\$249'),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '\$1,248',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _onCheckoutPressed,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _widthAnimation.value,
                height: 60,
                decoration: BoxDecoration(
                  color: _buttonColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: _buttonColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: _textOpacityAnimation.value,
                      child: const Text(
                        'Checkout',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Opacity(
                      opacity: _spinnerOpacityAnimation.value,
                      child: Transform.rotate(
                        angle: _spinnerRotationAnimation.value,
                        child: const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                    ),

                    // ── CHECKMARK ─────────────────
                    Opacity(
                      opacity: _checkOpacityAnimation.value,
                      child: Transform.scale(
                        scale: _checkScaleAnimation.value,
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_buttonState == _ButtonState.done)
              TextButton.icon(
                icon: const Icon(Icons.refresh),
                onPressed: onRest,
                label: const Text('Try again'),
              ),
          ],
        ),
      ),
    );
  }
}
