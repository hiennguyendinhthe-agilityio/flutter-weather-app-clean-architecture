import 'package:flutter/material.dart';
import 'package:flutter_application_2/mini_project/animation_showcase/home_screen.dart';

class ImplicitDemo extends StatefulWidget {
  const ImplicitDemo({super.key});

  @override
  State<ImplicitDemo> createState() => _ImplicitDemoState();
}

class _ImplicitDemoState extends State<ImplicitDemo> {
  bool _expanded = false;
  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          sectionTitle('AnimatedContainer'),
          const SizedBox(height: 16),

          Center(
            child: GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                width: _expanded ? 260 : 120,
                height: _expanded ? 260 : 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _expanded
                        ? [const Color(0xFF6C63FF), const Color(0xFF00BFA5)]
                        : [const Color(0xFFFF6B6B), const Color(0xFFFFB300)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(_expanded ? 40 : 20),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (_expanded
                                  ? const Color(0xFF6C63FF)
                                  : const Color(0xFFFF6B6B))
                              .withOpacity(0.4),
                      blurRadius: _expanded ? 30 : 10,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _expanded ? Icons.compress : Icons.expand,
                    color: Colors.white,
                    size: _expanded ? 48 : 28,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),
          Text(
            _expanded ? 'Tap to shrink' : 'Tap to expand',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),

          const SizedBox(height: 30),

          sectionTitle('AnimatedOpacity'),
          const SizedBox(height: 16),

          AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.visibility, color: Color(0xFF6C63FF)),
                  SizedBox(width: 12),
                  Text(
                    'Tôi có thể fade in/out!',
                    style: TextStyle(
                      color: Color(0xFF6C63FF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _opacity = _opacity == 1.0 ? 0.0 : 1.0;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(_opacity == 1.0 ? 'Fade Out' : 'Fade In'),
            ),
          ),
        ],
      ),
    );
  }
}
