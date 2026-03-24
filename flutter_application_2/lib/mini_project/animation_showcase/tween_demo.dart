import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/mini_project/animation_showcase/home_screen.dart';

class TweenDemo extends StatefulWidget {
  const TweenDemo({super.key});

  @override
  State<TweenDemo> createState() => _TweenDemoState();
}

class _TweenDemoState extends State<TweenDemo> {
  double _angle = 0;
  double _scale = 1.0;
  double _progress = 0.3;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          sectionTitle('Rotation Animation'),
          const SizedBox(height: 16),

          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: _angle),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Transform.rotate(angle: value, child: child);
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00BFA5), Color(0xFF6C63FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.navigation,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() => _angle -= pi / 2);
                },
                child: const Text('↺ -90°'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() => _angle += pi / 2);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BFA5),
                  foregroundColor: Colors.white,
                ),
                child: const Text('↻ +90°'),
              ),
            ],
          ),

          const SizedBox(height: 30),

          sectionTitle('Scale Animation'),
          const SizedBox(height: 16),

          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1.0, end: _scale),
              duration: const Duration(milliseconds: 400),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _scale = _scale == 1.0 ? 1.5 : 1.0;
                  });
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B6B).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),
          Text(
            'Tap heart to scale',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),

          const SizedBox(height: 30),

          sectionTitle('Progress Animation'),
          const SizedBox(height: 16),

          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: _progress),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Progress'),
                      Text(
                        '${(value * 100).toInt()}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00BFA5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 12,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF00BFA5),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 12),

          Slider(
            value: _progress,
            onChanged: (v) => setState(() => _progress = v),
            activeColor: const Color(0xFF00BFA5),
          ),
        ],
      ),
    );
  }
}
