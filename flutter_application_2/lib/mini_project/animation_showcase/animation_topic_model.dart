import 'package:flutter/material.dart';

class AnimationTopic {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const AnimationTopic({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

const List<AnimationTopic> topics = [
  AnimationTopic(
    id: 'implicit',
    title: 'Implicit',
    subtitle: 'AnimatedContainer',
    icon: Icons.auto_awesome,
    color: Color(0xFF6C63FF),
  ),
  AnimationTopic(
    id: 'tween',
    title: 'Tween Builder',
    subtitle: 'TweenAnimationBuilder',
    icon: Icons.transform,
    color: Color(0xFF00BFA5),
  ),
  AnimationTopic(
    id: 'explicit',
    title: 'Explicit',
    subtitle: 'AnimationController',
    icon: Icons.play_circle_filled,
    color: Color(0xFFFF6B6B),
  ),
  AnimationTopic(
    id: 'chart',
    title: 'Custom Paint',
    subtitle: 'Canvas + PathMetrics',
    icon: Icons.show_chart,
    color: Color(0xFFFFB300),
  ),
];
