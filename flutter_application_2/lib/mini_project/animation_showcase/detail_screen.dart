import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/explicit_animation/tween_demo.dart';
import 'package:flutter_application_2/implicit_animation/implicit_demo.dart';
import 'package:flutter_application_2/mini_project/animation_showcase/animation_topic_model.dart';
import 'package:flutter_application_2/mini_project/animation_showcase/home_screen.dart';

class DetailScreen extends StatelessWidget {
  final AnimationTopic topic;

  const DetailScreen({super.key, required this.topic});

  Widget get _demoWidget {
    switch (topic.id) {
      case 'implicit':
        return const ImplicitDemo();
      case 'tween':
        return const TweenDemo();
      case 'explicit':
        return const ExplicitDemo();
      case 'chart':
        return const ChartDemo();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: SafeArea(
        child: Column(
          children: [
            Hero(
              tag: topic.id,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: topic.color.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 16,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: topic.color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                topic.icon,
                                color: topic.color,
                                size: 24,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          topic.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(child: _demoWidget),
          ],
        ),
      ),
    );
  }
}
